module MetadataSpec.MetadataSpec (spec) where

import Metadata (PreReleaseType (..), Version (..))
import Test.Hspec (Spec, describe, it)

spec :: Spec
spec = do
  describe "Version.Eq" $ do
    it "compares two equal instances of version" $ do
      Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing "" == Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing "check"
  describe "Version.Ord" $ do
    it "checks if one version with different patch release is less than another" $ do
      Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing "" > Version Nothing [1, 2, 2] Nothing Nothing Nothing Nothing ""
    it "checks if one version with different minor release is less than another" $ do
      Version Nothing [1, 3, 3] Nothing Nothing Nothing Nothing "" > Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing ""
    it "checks if one version with different major release is less than another" $ do
      Version Nothing [2, 2, 3] Nothing Nothing Nothing Nothing "" > Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing ""
    it "checks if one version with epoch is less than another" $ do
      Version (Just 1) [1, 2, 3] Nothing Nothing Nothing Nothing "" > Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing ""
    it "checks if one version with different epoch is less than another" $ do
      Version (Just 2) [1, 2, 3] Nothing Nothing Nothing Nothing "" > Version (Just 1) [1, 2, 3] Nothing Nothing Nothing Nothing ""
    it "checks if one version with prerelease and another with no prerelease is less than another" $ do
      Version Nothing [1, 2, 3] (Just (Alpha, [1])) Nothing Nothing Nothing "" < Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing ""
