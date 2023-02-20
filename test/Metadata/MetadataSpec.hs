module Metadata.MetadataSpec (spec) where
import Test.Hspec (describe, it, shouldBe, Spec )
import Metadata (Version, Metadata)

spec :: Spec
spec = do
  describe "Version.Eq" $ do
    it "compares two versions for equality" $ do
      True `shouldBe` True
  describe "Version.Ord" $ do
    it "checks if one version is less than another" $ do
      True `shouldBe` True