{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Repository where

import           Data.Maybe (fromMaybe)
import           Data.Text  (Text)
import qualified Query

data RepositoryInfo = RepositoryInfo
  { name          :: Text
  , nameWithOwner :: Text
  , object        :: Maybe Commit
  } deriving (Eq, Show)

newtype Commit = Commit [TreeEntry] deriving (Eq, Show)

type TreeEntry = Query.SearchEdgesNodeObjectTreeEntriesTreeEntry

isBlob :: TreeEntry -> Bool
isBlob (Query.SearchEdgesNodeObjectTreeEntriesTreeEntry _ ty) = ty == "blob"

toRepositoryInfo :: Query.SearchEdgesSearchResultItemEdge -> Maybe RepositoryInfo
toRepositoryInfo (Query.SearchEdgesSearchResultItemEdge (Just (Query.SearchEdgesNodeRepository _ nameWithOwner name obj))) =
  Just RepositoryInfo {..}
  where
    object = case obj of
      (Just (Query.SearchEdgesNodeObjectCommit _ (Query.SearchEdgesNodeObjectTreeTree entries))) ->
        Just $ Commit (fromMaybe [] entries)
      _ ->
        Nothing
toRepositoryInfo _ = Nothing
