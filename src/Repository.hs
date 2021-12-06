{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE FlexibleContexts    #-}
{-# LANGUAGE OverloadedRecordDot #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE RecordWildCards     #-}

module Repository where

import           Data.Maybe (fromMaybe)
import           Data.Text  (Text)
import           GHC.Records
import qualified Query

data RepositoryInfo = RepositoryInfo
  { name          :: Text
  , nameWithOwner :: Text
  , object        :: Maybe Commit
  } deriving (Eq, Show)

newtype Commit = Commit [TreeEntry] deriving (Eq, Show)

type TreeEntry = Query.SearchEdgesNodeObjectTreeEntriesTreeEntry

isBlob :: (HasField "name" r Text, HasField "type'" r Text) => r -> Bool
isBlob entry = entry.type' == "blob"

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
