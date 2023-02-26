module Metadata where

data PreReleaseType = Alpha | Beta | Rc deriving (Show, Eq, Ord)

type Operator = String

type VersionConstraint = (Operator, Version)

type Requirement = (String, [VersionConstraint], String)

-- | PEP 440 compliant version data type
--
-- https://www.python.org/dev/peps/pep-0440/
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
              EQ -> case compare (dev v1) (dev v2) of
                LT -> LT
                GT -> GT
                EQ -> compare (local v1) (local v2)

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
