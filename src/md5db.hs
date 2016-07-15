----------------------------------------------------------------------------------------------
--
-- md5db.hs - Creates databases of md5 hashes from a word file, allows searching for hashes.
-- July, 15th, 2016
-- Copyright (C) 2016 Travis Montoya
--
----------------------------------------------------------------------------------------------
module Main where

import qualified Data.ByteString.Lazy.Char8 as LB8 (pack)
import qualified Data.ByteString.Char8      as B (putStr, putStrLn)
import qualified Data.ByteString.Internal
import Data.Char (ord)
import Crypto.Hash
import System.Environment (getArgs)
import System.IO

md5Str                :: [Char] -> Digest MD5
md5Str s              = hashlazy $ LB8.pack s

showMD5               :: [[Char]] -> Data.ByteString.Internal.ByteString
showMD5 s             = digestToHexByteString $ md5Str $ last s

----------------------------------------------------------------------------------------------
-- 
-- Run the program against a word list
--
----------------------------------------------------------------------------------------------
runMD5db              :: FilePath -> IO ()
runMD5db f            = do withFile f ReadMode (\wf -> do
                              putStrLn "Running.. This can take awhile!"
                              w        <- hGetContents wf
                              let md5s = zip (lines w) hashedWords
                                   where hashedWords = map md5Str (lines w)
                              putStrLn ("Saving database...")
                              saveDB md5s)

saveDB                :: [([Char], Digest MD5)] -> IO ()
saveDB m              = do withFile "md5db" WriteMode (\db -> do
                              sequence_ [hPutStrLn db (x ++ ":" ++ show y) | (x, y) <- m])

----------------------------------------------------------------------------------------------
-- 
-- Usage and Main program execution
--
----------------------------------------------------------------------------------------------
parseArgs             :: [[Char]] -> IO ()        
parseArgs ("run":s)   = runMD5db $ last s
parseArgs ("md5":s)   = B.putStrLn $ showMD5 s
parseArgs _           = printUsage

printUsage            :: IO ()
printUsage            = putStrLn ( "usage: md5db [OPTION] {ARG}\n" ++
                                   "OPTIONS:\n" ++
                                   "  run <file>        run md5db on the given wordfile\n" ++
                                   "  md5 <str>         return the md5 of <str>" )

-- Main execution
main                  :: IO ()
main                  = do args <- getArgs
                           parseArgs args
