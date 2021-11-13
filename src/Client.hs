{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE RecordWildCards       #-}

module Client where

import           Data.ByteString      (ByteString)
import qualified Data.ByteString.Lazy as Lazy
import           Data.Maybe           (catMaybes, mapMaybe)
import           Data.Morpheus.Client (fetch)
import           Data.Text            (Text)
import           Network.HTTP.Req
import qualified Query
import           Repository

resolver :: ByteString -> Lazy.ByteString -> IO Lazy.ByteString
resolver tok b = runReq defaultHttpConfig $ do
    let headers = header "Content-Type" "application/json"
               <> header "User-Agent" "github-grahql-example.hs"
               <> oAuth2Bearer tok
    responseBody <$> req POST (https "api.github.com" /: "graphql") (ReqBodyLbs b) lbsResponse headers

searchRepository :: ByteString -> Text -> IO (Either String [RepositoryInfo])
searchRepository tok query = go [] (Query.SearchPageInfoPageInfo Nothing True)
  where
    fetch' = fetch (resolver tok)
    go xs (Query.SearchPageInfoPageInfo _ False) = pure (Right xs)
    go xs (Query.SearchPageInfoPageInfo cursor _) = do
      result <- fetch' Query.SearchRepositoryArgs {..}
      case result of
        Left e ->
          pure $ Left (show e)
        Right (Query.SearchRepository (Query.SearchSearchResultItemConnection _ next edges)) ->
          let repos = maybe [] (mapMaybe toRepositoryInfo . catMaybes) edges in
          go (repos ++ xs) next
