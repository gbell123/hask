-- Directives or settings or something
  {-# LANGUAGE OverloadedStrings #-}
  {-# LANGUAGE QuasiQuotes #-}
-- /

-- Warp includes
  import Network.Wai
  import Network.Wai.Handler.Warp
  import Network.HTTP.Types (status200, status404, status501) -- TODO: import them all for simplicity maybe...
  import Blaze.ByteString.Builder (copyByteString)
  import qualified Data.ByteString.UTF8 as BU
  import Data.Monoid
-- /

-- Shakespeare includes
  import Text.Hamlet (shamlet, shamletFile)
  import Text.Blaze.Html.Renderer.String (renderHtml)
  import Data.Char (toLower)
  import Data.List (sort)
-- /
 
-- The Fuckin' Show
  main = do
    let port = 3000
    putStrLn $ "Listening on port " ++ show port
    run port app
   
  app req respond = respond $
    case pathInfo req of
    	-- routing
      ["home"] -> home
      ["man"] -> man
      ["about"] -> about
      x -> def x
-- /

-- Responders
  home = respond ["Welcome to the home page, mutha fucka."] 200

  man = respond ["Man pages can be displayed at this route."] 200

  about = respond ["About us or some other shit whatever."] 200

  def x = respond ( renderHtml ( $(shamletFile "404.hamlet") ) ) 404
-- /

-- Utilities
  -- TODO: HTML, not plain
  respond string code = 
    case code of
      200 -> responseBuilder status200 [ ("Content-Type", "text/plain") ] $ mconcat $ map copyByteString string
      404 -> responseBuilder status404 [ ("Content-Type", "text/plain") ] $ mconcat string
      x  -> responseBuilder status501 [ ("Content-Type", "text/plain") ] $ mconcat $ map copyByteString ["Unhandled response code!"]
-- /
