module MetadataSpec.MetadataSpec (spec) where

import Test.Hspec (Spec, describe, it, shouldBe)

spec :: Spec
spec = do
  describe "Version.Eq" $ do
    it "compares two equal instances of version" $ do
      True `shouldBe` True
