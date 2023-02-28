module Metadata where

import Data.List.Split (splitOn)
import Text.Regex.PCRE

data PreReleaseType = Alpha | Beta | Rc deriving (Show, Eq, Ord)

type Operator = String

type VersionConstraint = (Operator, Version)

type Requirement = (String, [VersionConstraint], String)

-- | PEP 440 compliant version data type
--
-- - https://www.python.org/dev/peps/pep-0440/
data Version = Version
  { epoch :: Maybe Int,
    release :: [Int],
    pre :: Maybe (PreReleaseType, [Int]),
    post :: Maybe Int,
    dev :: Maybe Int,
    local :: Maybe String,
    versionString :: String
  }
  deriving (Show)

instance Eq Version where
  (==) v1 v2 =
    epoch v1 == epoch v2
      && release v1 == release v2
      && pre v1 == pre v2
      && post v1 == post v2
      && dev v1 == dev v2
      && local v1 == local v2

instance Ord Version where
  compare v1 v2 =
    case compare (epoch v1) (epoch v2) of
      LT -> LT
      GT -> GT
      EQ -> case compare (release v1) (release v2) of
        LT -> LT
        GT -> GT
        EQ -> case (pre v1, pre v2) of
          (Nothing, Just _) -> GT
          (Just _, Nothing) -> LT
          (a, b) -> case compare a b of
            LT -> LT
            GT -> GT
            EQ -> case compare (post v1) (post v2) of
              LT -> LT
              GT -> GT
              EQ -> case (dev v1, dev v2) of
                (Nothing, Just _) -> GT
                (Just _, Nothing) -> LT
                (a', b') -> case compare a' b' of
                  LT -> LT
                  GT -> GT
                  EQ -> compare (local v1) (local v2)

-- | Parse a PEP 440 compliant version string
parseVersionFromString :: String -> Maybe Version
parseVersionFromString s =
  case s =~ "^(?:(\\d+)!)?(\\d+(?:\\.\\d+)*)((?:a|b|rc)\\d+)?(?:\\.post(\\d+))?(?:\\.dev(\\d+))?(?:\\+(.*))?$" :: [[String]] of
    [[_, epoch', release', pre', post', dev', local']] ->
      Just $
        Version
          { epoch = if null epoch' then Nothing else Just (read epoch'),
            release = map read $ splitOn "." release',
            pre = if null pre' then Nothing else Just (parsePreType $ take 2 pre', map read $ splitOn "." $ drop 2 pre'),
            post = if null post' then Nothing else Just (read post'),
            dev = if null dev' then Nothing else Just (read dev'),
            local = if null local' then Nothing else Just local',
            versionString = s
          }
    _ -> Nothing

parsePreType :: String -> PreReleaseType
parsePreType "a" = Alpha
parsePreType "b" = Beta
parsePreType "rc" = Rc
parsePreType s = error $ "Invalid pre-release type: " ++ s

-- | PEP 566 compliant metadata data type
--
-- - https://peps.python.org/pep-0566/
-- - https://packaging.python.org/en/latest/specifications/core-metadata/
data Metadata = Metadata
  { metadataVersion :: Version,
    name :: String,
    version :: Version,
    dynamic :: Maybe String,
    platforms :: Maybe [String],
    supportedPlatforms :: Maybe [String],
    summary :: Maybe String,
    description :: Maybe String,
    descriptionContentType :: Maybe String,
    keywords :: Maybe [String],
    homepage :: Maybe String,
    downloadUrl :: Maybe String,
    author :: Maybe String,
    authorEmail :: Maybe String,
    maintainer :: Maybe String,
    maintainerEmail :: Maybe String,
    license :: Maybe String,
    classifiers :: Maybe [String],
    requiresDist :: Maybe [Requirement],
    requiresPython :: Maybe [VersionConstraint],
    requiresExternals :: Maybe [String],
    projectUrls :: Maybe [String],
    providesExtras :: Maybe [String]
  }
  deriving (Show, Eq)
