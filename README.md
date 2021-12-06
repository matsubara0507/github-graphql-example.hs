# github-graphql-example

```
ghci> :set -XOverloadedRecordDot -XOverloadedStrings
ghci> import Data.ByteString (ByteString)
ghci> token = "ghp_xxxx" :: ByteString
ghci> 
ghci> Right [repo] <- searchRepository token "repo:matsubara0507/stack-templates"
ghci> Just (Commit entries1) = repo.object
ghci> map (\x -> x.name) $ filter isBlob entries1
["LICENSE","README.md","get-opt-cli.hsfiles","lib-extensible.hsfiles","mix-cli-with-bazel.hsfiles","mix-cli.hsfiles","optparse-applicative-cli.hsfiles"]
ghci> 
ghci> Right entries2 <- fetchRepositoryTreeEntries token "matsubara0507" "stack-templates"
ghci> map (\x -> x.name) $ filter isBlob entries2
["LICENSE","README.md","get-opt-cli.hsfiles","lib-extensible.hsfiles","mix-cli-with-bazel.hsfiles","mix-cli.hsfiles","optparse-applicative-cli.hsfiles"]
```
