{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE DerivingStrategies    #-}
{-# LANGUAGE DuplicateRecordFields #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}

module Query where

import           Data.Morpheus.Client
import           Data.Text            (Text)

-- | MEMO: need `__typename` for interface on morpheus-graphql-client-0.18.0
defineByDocumentFile "./assets/schema.docs.graphql"
  [gql|
    query SearchRepository($query: String!, $cursor: String) {
      search(query: $query, type: REPOSITORY, first: 100, after: $cursor) {
        repositoryCount,
        pageInfo { endCursor, hasNextPage }
        edges {
          node {
            ... on Repository {
              __typename
              nameWithOwner,
              name,
              object(expression: "HEAD") {
                ... on Commit { __typename, tree { entries { name, type } } }
              }
            }
          }
        }
      }
    }
  |]

defineByDocumentFile "./assets/schema.docs.graphql"
  [gql|
    query GetReository($owner: String!, $name: String!) {
      repository(owner: $owner, name: $name) {
        object(expression: "HEAD") {
          ... on Commit { __typename, tree { entries { name, type } } }
        }
      }
    }
  |]
