module MetadataSpec.VersionSpec (spec) where

import Metadata (PreReleaseType (..), Version (..), parseVersionFromString)
import Test.Hspec (Spec, describe, it, shouldBe)

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
    it "checks if one version with alpha prerelease is less than another with beta prerelease" $ do
      Version Nothing [1, 2, 3] (Just (Alpha, [1])) Nothing Nothing Nothing "" < Version Nothing [1, 2, 3] (Just (Beta, [1])) Nothing Nothing Nothing ""
    it "checks if one version with beta prerelease is less than another with rc prerelease" $ do
      Version Nothing [1, 2, 3] (Just (Beta, [1])) Nothing Nothing Nothing "" < Version Nothing [1, 2, 3] (Just (Rc, [1])) Nothing Nothing Nothing ""
    it "checks if one version with rc prerelease is less than another with no prerelease" $ do
      Version Nothing [1, 2, 3] (Just (Rc, [1])) Nothing Nothing Nothing "" < Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing ""
    it "checks if one version with no post release is less than another with post release" $ do
      Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing "" < Version Nothing [1, 2, 3] Nothing (Just 1) Nothing Nothing ""
    it "checks if a version with dev release is less than another with no dev release" $ do
      Version Nothing [1, 2, 3] Nothing Nothing (Just 1) Nothing "" < Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing ""
    it "checks if a version with no local release is less than another with local release" $ do
      Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing "" < Version Nothing [1, 2, 3] Nothing Nothing Nothing (Just "local") ""

  describe "Parse version froms string" $ do
    it "parses version with only release version 1.2.3" $ do
      parseVersionFromString "1.2.3" `shouldBe` Just (Version Nothing [1, 2, 3] Nothing Nothing Nothing Nothing "1.2.3")
    it "parses version with only release version 2.5.5" $ do
      parseVersionFromString "2.5.5" `shouldBe` Just (Version Nothing [2, 5, 5] Nothing Nothing Nothing Nothing "2.5.5")
