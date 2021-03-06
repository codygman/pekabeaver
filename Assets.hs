{-# LANGUAGE CPP, FlexibleContexts, TemplateHaskell #-}

module Assets
	( Vertex(..)
	, fieldGeometry
	, beaverGeometry
	, pekaGeometry
	, fieldTexture
	, beaverTexture
	, pekaTexture
	) where

import Control.Monad.IO.Class
import Control.Monad.Trans.Control
import Control.Monad.Trans.Resource
import qualified Data.ByteString as B
import Data.Word
import Foreign.Storable
import Language.Haskell.TH

import Flaw.Asset.Collada
import Flaw.Asset.Geometry
import Flaw.Build
import Flaw.Game
import Flaw.Game.Texture
import Flaw.Graphics
import Flaw.Graphics.Texture

import AssetTypes

type Geometry = (VertexBufferId GameGraphicsDevice, IndexBufferId GameGraphicsDevice, Int)

fieldGeometry :: (MonadResource m, MonadBaseControl IO m) => GameGraphicsDevice -> m Geometry
#if ghcjs_HOST_OS
fieldGeometry device = do
	verticesBytes <- liftIO $(embedIOExp =<< loadFile "assets/field.vertices")
	indicesBytes <- liftIO $(embedIOExp =<< loadFile "assets/field.indices")
	let indicesCount = 50868
	let isIndices32Bit = False
	(_, vb) <- createStaticVertexBuffer device verticesBytes (sizeOf (undefined :: Vertex))
	(_, ib) <- createStaticIndexBuffer device indicesBytes isIndices32Bit
	return (vb, ib, indicesCount)
#else
fieldGeometry = $(loadGeometry "assets/field.DAE" "geom-field")
#endif

beaverGeometry :: (MonadResource m, MonadBaseControl IO m) => GameGraphicsDevice -> m Geometry
beaverGeometry = $(loadGeometry "assets/beaver.DAE" "geom-Beaver")

pekaGeometry :: (MonadResource m, MonadBaseControl IO m) => GameGraphicsDevice -> m Geometry
pekaGeometry = $(loadGeometry "assets/peka.DAE" "geom-peka")

fieldTexture :: (MonadResource m, MonadBaseControl IO m) => GameGraphicsDevice -> m (ReleaseKey, TextureId GameGraphicsDevice)
fieldTexture = $(loadTextureExp "assets/images/0_castle.jpg")

beaverTexture :: (MonadResource m, MonadBaseControl IO m) => GameGraphicsDevice -> m (ReleaseKey, TextureId GameGraphicsDevice)
beaverTexture = $(loadTextureExp "assets/images/0_beaver.jpg")

pekaTexture :: (MonadResource m, MonadBaseControl IO m) => GameGraphicsDevice -> m (ReleaseKey, TextureId GameGraphicsDevice)
pekaTexture = $(loadTextureExp "assets/images/0_peka0.png")
