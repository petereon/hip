

data PreReleaseType = Alpha | Beta | Rc deriving (Show, Eq, Ord)

type Operator = String
type VersionConstraint = (Operator, Version)
type Requirement = (String, [VersionConstraint], Extra)


data Version = Version
    { epoch :: Maybe Int
    , release :: [Int]
    , pre :: Maybe (PreReleaseType, [Int])
    , post :: Maybe Int
    , dev :: Maybe Int
    , local :: Maybe String
    , versionString :: String
    } deriving (Show, Eq)

data Metadata = Metadata
    { metadataVersion :: Version
    , name :: String
    , version :: Version
    , dynamic :: Maybe String
    , platforms :: Maybe [String]
    , supportedPlatforms :: Maybe [String]
    , summary :: Maybe String
    , description :: Maybe String
    , descriptionContentType :: Maybe String
    , keywords :: Maybe [String]
    , homepage :: Maybe String
    , downloadUrl :: Maybe String
    , author :: Maybe String
    , authorEmail :: Maybe String
    , maintainer :: Maybe String
    , maintainerEmail :: Maybe String
    , license :: Maybe String
    , classifiers :: Maybe [String]
    , requiresDist :: Maybe [Requirement]
    , requiresPython :: Maybe [VersionConstraint]
    , requiresExternals :: Maybe [String]
    , projectUrls :: Maybe [String]
    , providesExtras :: Maybe [String]
    }
    deriving (Show, Eq)
