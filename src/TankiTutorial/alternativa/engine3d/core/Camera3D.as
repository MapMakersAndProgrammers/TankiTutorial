package alternativa.engine3d.core
{
   import alternativa.gfx.core.VertexBufferResource;
   import alternativa.gfx.core.Device;
   import alternativa.gfx.core.TextureResource;
   import alternativa.gfx.core.IndexBufferResource;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.lights.SpotLight;
   import alternativa.engine3d.lights.TubeLight;
   import alternativa.engine3d.materials.Material;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.StageAlign;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DClearMask;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DStencilAction;
   import flash.display3D.Context3DTriangleFace;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getQualifiedSuperclassName;
   import flash.utils.getTimer;
   
   use namespace alternativa3d;
   
   public class Camera3D extends Object3D
   {
      
      public var view:View;
      
      public var fov:Number = 1.5707963267948966;
      
      public var nearClipping:Number = 1;
      
      public var farClipping:Number = 1000000;
      
      public var onRender:Function;
      
      alternativa3d var viewSizeX:Number;
      
      alternativa3d var viewSizeY:Number;
      
      alternativa3d var focalLength:Number;
      
      alternativa3d var correctionX:Number;
      
      alternativa3d var correctionY:Number;
      
      alternativa3d var lights:Vector.<Light3D> = new Vector.<Light3D>();
      
      alternativa3d var lightsLength:int = 0;
      
      alternativa3d var occluders:Vector.<Vertex> = new Vector.<Vertex>();
      
      alternativa3d var numOccluders:int;
      
      alternativa3d var occludedAll:Boolean;
      
      alternativa3d var numDraws:int;
      
      alternativa3d var numShadows:int;
      
      alternativa3d var numTriangles:int;
      
      alternativa3d var device:Device;
      
      alternativa3d var projection:Vector.<Number> = new Vector.<Number>(4);
      
      alternativa3d var correction:Vector.<Number> = new Vector.<Number>(4);
      
      alternativa3d var transform:Vector.<Number> = new Vector.<Number>(12);
      
      private var opaqueMaterials:Vector.<Material> = new Vector.<Material>();
      
      private var opaqueVertexBuffers:Vector.<VertexBufferResource> = new Vector.<VertexBufferResource>();
      
      private var opaqueIndexBuffers:Vector.<IndexBufferResource> = new Vector.<IndexBufferResource>();
      
      private var opaqueRanges:Vector.<int> = new Vector.<int>();
      
      private var opaqueObjects:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var opaqueCount:int = 0;
      
      private var transparentFaceLists:Vector.<Face> = new Vector.<Face>();
      
      private var transparentObjects:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var transparentCount:int = 0;
      
      private var transparentOpaqueFaceLists:Vector.<Face> = new Vector.<Face>();
      
      private var transparentOpaqueObjects:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var transparentOpaqueCount:int = 0;
      
      private var decalFaceLists:Vector.<Face> = new Vector.<Face>();
      
      private var decalObjects:Vector.<Object3D> = new Vector.<Object3D>();
      
      private var decalCount:int = 0;
      
      alternativa3d var depthObjects:Vector.<Object3D> = new Vector.<Object3D>();
      
      alternativa3d var depthCount:int = 0;
      
      alternativa3d var casterObjects:Vector.<Object3D> = new Vector.<Object3D>();
      
      alternativa3d var casterCount:int = 0;
      
      alternativa3d var shadedTransparentObjects:Dictionary = new Dictionary();
      
      alternativa3d var shadowAtlases:Array = new Array();
      
      alternativa3d var receiversVertexBuffers:Vector.<VertexBufferResource>;
      
      alternativa3d var receiversIndexBuffers:Vector.<IndexBufferResource>;
      
      alternativa3d var gma:Number;
      
      alternativa3d var gmb:Number;
      
      alternativa3d var gmc:Number;
      
      alternativa3d var gmd:Number;
      
      alternativa3d var gme:Number;
      
      alternativa3d var gmf:Number;
      
      alternativa3d var gmg:Number;
      
      alternativa3d var gmh:Number;
      
      alternativa3d var gmi:Number;
      
      alternativa3d var gmj:Number;
      
      alternativa3d var gmk:Number;
      
      alternativa3d var gml:Number;
      
      alternativa3d var fogParams:Vector.<Number> = Vector.<Number>([1,0,0,1]);
      
      alternativa3d var fogFragment:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      private var shadows:Dictionary = new Dictionary();
      
      private var shadowList:Vector.<Shadow> = new Vector.<Shadow>();
      
      private var depthRenderer:DepthRenderer = new DepthRenderer();
      
      alternativa3d var depthMap:TextureResource;
      
      alternativa3d var lightMap:TextureResource;
      
      private var softParams:Vector.<Number> = Vector.<Number>([0,0,0,0.5]);
      
      private var ssaoParams:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      private var lightTransform:Vector.<Number> = Vector.<Number>([0,0,0,1]);
      
      private var lightParams:Vector.<Number> = Vector.<Number>([0,0,0,1,0,0,0,1]);
      
      alternativa3d var omnies:Vector.<OmniLight> = new Vector.<OmniLight>();
      
      alternativa3d var omniesCount:int = 0;
      
      alternativa3d var spots:Vector.<SpotLight> = new Vector.<SpotLight>();
      
      alternativa3d var spotsCount:int = 0;
      
      alternativa3d var tubes:Vector.<TubeLight> = new Vector.<TubeLight>();
      
      alternativa3d var tubesCount:int = 0;
      
      public var fogNear:Number = 0;
      
      public var fogFar:Number = 1000000;
      
      public var fogAlpha:Number = 0;
      
      public var fogColor:int = 8355711;
      
      public var softTransparency:Boolean = false;
      
      public var depthBufferScale:Number = 1;
      
      public var ssao:Boolean = false;
      
      public var ssaoRadius:Number = 100;
      
      public var ssaoRange:Number = 1000;
      
      public var ssaoColor:int = 0;
      
      public var ssaoAlpha:Number = 1;
      
      public var directionalLight:DirectionalLight;
      
      public var shadowMap:ShadowMap;
      
      public var ambientColor:int = 0;
      
      public var deferredLighting:Boolean = false;
      
      public var fogStrength:Number = 1;
      
      public var softTransparencyStrength:Number = 1;
      
      public var ssaoStrength:Number = 1;
      
      public var directionalLightStrength:Number = 1;
      
      public var shadowMapStrength:Number = 1;
      
      public var shadowsStrength:Number = 1;
      
      public var shadowsDistanceMultiplier:Number = 1;
      
      public var deferredLightingStrength:Number = 1;
      
      public var debug:Boolean = false;
      
      private var debugSet:Object = new Object();
      
      private var _diagram:Sprite = createDiagram();
      
      public var fpsUpdatePeriod:int = 10;
      
      public var timerUpdatePeriod:int = 10;
      
      private var fpsTextField:TextField;
      
      private var memoryTextField:TextField;
      
      private var drawsTextField:TextField;
      
      private var shadowsTextField:TextField;
      
      private var trianglesTextField:TextField;
      
      private var timerTextField:TextField;
      
      private var graph:Bitmap;
      
      private var rect:Rectangle;
      
      private var _diagramAlign:String = "TR";
      
      private var _diagramHorizontalMargin:Number = 2;
      
      private var _diagramVerticalMargin:Number = 2;
      
      private var fpsUpdateCounter:int;
      
      private var previousFrameTime:int;
      
      private var previousPeriodTime:int;
      
      private var maxMemory:int;
      
      private var timerUpdateCounter:int;
      
      private var timeSum:int;
      
      private var timeCount:int;
      
      private var timer:int;
      
      private var firstVertex:Vertex = new Vertex();
      
      private var firstFace:Face = new Face();
      
      private var firstWrapper:Wrapper = new Wrapper();
      
      alternativa3d var lastWrapper:Wrapper = firstWrapper;
      
      alternativa3d var lastVertex:Vertex = firstVertex;
      
      alternativa3d var lastFace:Face = firstFace;
      
      public function Camera3D()
      {
         super();
      }
      
      public function addShadow(shadow:Shadow) : void
      {
         this.shadows[shadow] = true;
      }
      
      public function removeShadow(shadow:Shadow) : void
      {
         delete this.shadows[shadow];
      }
      
      public function removeAllShadows() : void
      {
         this.shadows = new Dictionary();
      }
      
      public function render() : void
      {
         var i:int = 0;
         var k:int = 0;
         var key:* = undefined;
         var shadow:Shadow = null;
         var faceList:Face = null;
         var object:Object3D = null;
         var lastBlendMode:String = null;
         var root:Object3D = null;
         var light:Light3D = null;
         var atlas:ShadowAtlas = null;
         var hasShadows:Boolean = false;
         var material:Material = null;
         var range:int = 0;
         var shadowListLength:int = 0;
         var j:int = 0;
         var v:int = 0;
         var lastTexture:TextureResource = null;
         var onTop:Boolean = false;
         var next:Face = null;
         var lastNumTriangles:int = 0;
         var shadedObject:Object3D = null;
         this.numDraws = 0;
         this.numShadows = 0;
         this.numTriangles = 0;
         if(this.view != null && this.view.device != null && this.view.device.ready)
         {
            this.device = this.view.device;
            this.view.configure();
            if(this.nearClipping < 1)
            {
               this.nearClipping = 1;
            }
            if(this.farClipping > 1000000)
            {
               this.farClipping = 1000000;
            }
            this.viewSizeX = this.view._width * 0.5;
            this.viewSizeY = this.view._height * 0.5;
            this.focalLength = Math.sqrt(this.viewSizeX * this.viewSizeX + this.viewSizeY * this.viewSizeY) / Math.tan(this.fov * 0.5);
            this.correctionX = this.viewSizeX / this.focalLength;
            this.correctionY = this.viewSizeY / this.focalLength;
            this.projection[0] = 1 << this.view.zBufferPrecision;
            this.projection[1] = 1;
            this.projection[2] = this.farClipping / (this.farClipping - this.nearClipping);
            this.projection[3] = this.nearClipping * this.farClipping / (this.nearClipping - this.farClipping);
            this.composeCameraMatrix();
            for(root = this; root._parent != null; )
            {
               root = root._parent;
               root.composeMatrix();
               appendMatrix(root);
            }
            this.gma = ma;
            this.gmb = mb;
            this.gmc = mc;
            this.gmd = md;
            this.gme = me;
            this.gmf = mf;
            this.gmg = mg;
            this.gmh = mh;
            this.gmi = mi;
            this.gmj = mj;
            this.gmk = mk;
            this.gml = ml;
            invertMatrix();
            this.transform[0] = ma;
            this.transform[1] = mb;
            this.transform[2] = mc;
            this.transform[3] = md;
            this.transform[4] = me;
            this.transform[5] = mf;
            this.transform[6] = mg;
            this.transform[7] = mh;
            this.transform[8] = mi;
            this.transform[9] = mj;
            this.transform[10] = mk;
            this.transform[11] = ml;
            this.numOccluders = 0;
            this.occludedAll = false;
            if(root != this && root.visible)
            {
               this.lightsLength = 0;
               for(light = (root as Object3DContainer).lightList; light != null; )
               {
                  if(light.visible)
                  {
                     light.calculateCameraMatrix(this);
                     if(light.checkFrustumCulling(this))
                     {
                        this.lights[this.lightsLength] = light;
                        ++this.lightsLength;
                        if(!this.view.constrained && this.deferredLighting && this.deferredLightingStrength > 0)
                        {
                           if(light is OmniLight)
                           {
                              this.omnies[this.omniesCount] = light as OmniLight;
                              ++this.omniesCount;
                           }
                           else if(light is SpotLight)
                           {
                              this.spots[this.spotsCount] = light as SpotLight;
                              ++this.spotsCount;
                           }
                           else if(light is TubeLight)
                           {
                              this.tubes[this.tubesCount] = light as TubeLight;
                              ++this.tubesCount;
                           }
                        }
                     }
                  }
                  light = light.nextLight;
               }
               root.appendMatrix(this);
               root.cullingInCamera(this,63);
               if(this.debug)
               {
                  i = 0;
                  while(i < this.lightsLength)
                  {
                     (this.lights[i] as Light3D).drawDebug(this);
                     i++;
                  }
               }
               hasShadows = false;
               if(!this.view.constrained && this.shadowsStrength > 0)
               {
                  for(key in this.shadows)
                  {
                     shadow = key;
                     if(shadow.checkVisibility(this))
                     {
                        k = shadow.mapSize + shadow.blur;
                        atlas = this.shadowAtlases[k];
                        if(atlas == null)
                        {
                           atlas = new ShadowAtlas(shadow.mapSize,shadow.blur);
                           this.shadowAtlases[k] = atlas;
                        }
                        atlas.shadows[atlas.shadowsCount] = shadow;
                        ++atlas.shadowsCount;
                        hasShadows = true;
                     }
                  }
               }
               this.device.setCulling(Context3DTriangleFace.FRONT);
               this.device.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
               this.device.setStencilActions(Context3DTriangleFace.NONE);
               this.device.setStencilReferenceValue(0);
               if(hasShadows)
               {
                  this.device.setCulling(Context3DTriangleFace.BACK);
                  this.device.setDepthTest(true,Context3DCompareMode.GREATER_EQUAL);
                  this.device.setProgram(Shadow.getCasterProgram());
                  for each(atlas in this.shadowAtlases)
                  {
                     if(atlas.shadowsCount > 0)
                     {
                        atlas.renderCasters(this);
                     }
                  }
                  this.device.setCulling(Context3DTriangleFace.FRONT);
                  this.device.setDepthTest(false,Context3DCompareMode.ALWAYS);
                  for each(atlas in this.shadowAtlases)
                  {
                     if(atlas.shadowsCount > 0)
                     {
                        atlas.renderBlur(this);
                     }
                  }
                  this.device.setTextureAt(0,null);
                  this.device.setVertexBufferAt(1,null);
               }
               if(this.directionalLight != null)
               {
                  this.directionalLight.composeAndAppend(this);
                  this.directionalLight.calculateInverseMatrix();
               }
               root.concatenatedAlpha = root.alpha;
               root.concatenatedBlendMode = root.blendMode;
               root.concatenatedColorTransform = root.colorTransform;
               root.draw(this);
               this.device.setDepthTest(true,Context3DCompareMode.LESS);
               if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.shadowMap.calculateBounds(this);
                  this.shadowMap.render(this,this.casterObjects,this.casterCount);
               }
               this.depthMap = null;
               this.lightMap = null;
               if(!this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0 || this.deferredLighting && this.deferredLightingStrength > 0))
               {
                  this.depthRenderer.render(this,this.view._width,this.view._height,this.depthBufferScale,this.ssao && this.ssaoStrength > 0,this.deferredLighting && this.deferredLightingStrength > 0,this.directionalLight != null && this.directionalLightStrength > 0 || this.shadowMap != null && this.shadowMapStrength > 0 ? 0 : 0.5,this.depthObjects,this.depthCount);
                  if(this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0)
                  {
                     this.depthMap = this.depthRenderer.depthBuffer;
                  }
                  if(this.deferredLighting && this.deferredLightingStrength > 0)
                  {
                     this.lightMap = this.depthRenderer.lightBuffer;
                  }
               }
               else
               {
                  this.depthRenderer.resetResources();
               }
               if(hasShadows || !this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0 || this.deferredLighting && this.deferredLightingStrength > 0) || !this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.device.setRenderToBackBuffer();
               }
               this.view.clearArea();
               this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,3,this.projection,1);
               this.correction[0] = this.view.rect.width / this.device.width;
               this.correction[1] = this.view.rect.height / this.device.height;
               this.correction[2] = (this.view.rect.x * 2 + this.view.rect.width - this.device.width) / this.device.width;
               this.correction[3] = (this.view.rect.y * 2 + this.view.rect.height - this.device.height) / this.device.height;
               this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,13,this.correction,1);
               if(!this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0 || this.deferredLighting && this.deferredLightingStrength > 0))
               {
                  this.softParams[0] = this.depthRenderer.correctionX;
                  this.softParams[1] = this.depthRenderer.correctionY;
                  this.softParams[2] = 255 / this.farClipping;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,4,this.softParams,1);
                  if(this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0)
                  {
                     this.ssaoParams[0] = (1 - 2 * (this.ssaoColor >> 16 & 0xFF) / 255) * this.ssaoAlpha * this.ssaoStrength;
                     this.ssaoParams[1] = (1 - 2 * (this.ssaoColor >> 8 & 0xFF) / 255) * this.ssaoAlpha * this.ssaoStrength;
                     this.ssaoParams[2] = (1 - 2 * (this.ssaoColor & 0xFF) / 255) * this.ssaoAlpha * this.ssaoStrength;
                     this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,12,this.ssaoParams,1);
                  }
               }
               if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,6,this.shadowMap.transform,4);
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,5,this.shadowMap.params,5);
               }
               if(this.fogAlpha > 0 && this.fogStrength > 0)
               {
                  this.fogParams[2] = this.fogNear;
                  this.fogParams[3] = this.fogFar - this.fogNear;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,5,this.fogParams,1);
                  this.fogFragment[0] = (this.fogColor >> 16 & 0xFF) / 255;
                  this.fogFragment[1] = (this.fogColor >> 8 & 0xFF) / 255;
                  this.fogFragment[2] = (this.fogColor & 0xFF) / 255;
                  this.fogFragment[3] = this.fogAlpha * this.fogStrength;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,this.fogFragment,1);
               }
               if(!this.view.constrained && this.directionalLight != null && this.directionalLightStrength > 0)
               {
                  this.lightTransform[0] = -this.directionalLight.imi;
                  this.lightTransform[1] = -this.directionalLight.imj;
                  this.lightTransform[2] = -this.directionalLight.imk;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,10,this.lightTransform,1);
                  this.lightParams[0] = this.directionalLight.intensity * (this.directionalLight.color >> 16 & 0xFF) * 2 * this.directionalLightStrength / 255;
                  this.lightParams[1] = this.directionalLight.intensity * (this.directionalLight.color >> 8 & 0xFF) * 2 * this.directionalLightStrength / 255;
                  this.lightParams[2] = this.directionalLight.intensity * (this.directionalLight.color & 0xFF) * 2 * this.directionalLightStrength / 255;
                  this.lightParams[4] = 1 + ((this.ambientColor >> 16 & 0xFF) * 2 / 255 - 1) * this.directionalLightStrength;
                  this.lightParams[5] = 1 + ((this.ambientColor >> 8 & 0xFF) * 2 / 255 - 1) * this.directionalLightStrength;
                  this.lightParams[6] = 1 + ((this.ambientColor & 0xFF) * 2 / 255 - 1) * this.directionalLightStrength;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,10,this.lightParams,2);
               }
               else if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.lightParams[0] = 0;
                  this.lightParams[1] = 0;
                  this.lightParams[2] = 0;
                  this.lightParams[4] = 1;
                  this.lightParams[5] = 1;
                  this.lightParams[6] = 1;
                  this.device.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,10,this.lightParams,2);
               }
               if(!this.view.constrained && this.ssao && this.ssaoStrength > 0)
               {
                  this.device.setTextureAt(1,this.depthMap);
               }
               if(!this.view.constrained && this.deferredLighting && this.deferredLightingStrength > 0)
               {
                  this.device.setTextureAt(5,this.lightMap);
               }
               if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.device.setTextureAt(2,this.shadowMap.map);
                  this.device.setTextureAt(3,this.shadowMap.noise);
               }
               for(i = 0; i < this.opaqueCount; i++)
               {
                  material = this.opaqueMaterials[i];
                  range = this.opaqueRanges[i];
                  material.drawOpaque(this,this.opaqueVertexBuffers[i],this.opaqueIndexBuffers[i],range >> 16,range & 0xFFFF,this.opaqueObjects[i]);
               }
               this.device.setVertexBufferAt(1,null);
               this.device.setDepthTest(false,Context3DCompareMode.LESS);
               for(lastBlendMode = ""; this.decalCount > 0; )
               {
                  --this.decalCount;
                  faceList = this.decalFaceLists[this.decalCount];
                  object = this.decalObjects[this.decalCount];
                  if(object.concatenatedBlendMode != lastBlendMode)
                  {
                     lastBlendMode = object.concatenatedBlendMode;
                     if(lastBlendMode == "add" || lastBlendMode == "screen")
                     {
                        this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
                     }
                     else
                     {
                        this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                     }
                  }
                  faceList.material.drawTransparent(this,faceList,object);
               }
               this.device.setTextureAt(0,null);
               this.device.setTextureAt(1,null);
               this.device.setTextureAt(2,null);
               this.device.setTextureAt(3,null);
               this.device.setTextureAt(5,null);
               if(hasShadows)
               {
                  shadowListLength = 0;
                  for each(atlas in this.shadowAtlases)
                  {
                     for(i = 0; i < atlas.shadowsCount; i++)
                     {
                        this.shadowList[shadowListLength] = atlas.shadows[i];
                        shadowListLength++;
                     }
                  }
                  this.device.setDepthTest(false,Context3DCompareMode.LESS);
                  lastTexture = null;
                  for(i = 0; i < shadowListLength; i += 8)
                  {
                     if(i > 0)
                     {
                        this.device.clear(0,0,0,0,1,0,Context3DClearMask.STENCIL);
                     }
                     this.device.setBlendFactors(Context3DBlendFactor.ZERO,Context3DBlendFactor.ONE);
                     this.device.setCulling(Context3DTriangleFace.NONE);
                     this.device.setStencilActions(Context3DTriangleFace.FRONT_AND_BACK,Context3DCompareMode.ALWAYS,Context3DStencilAction.INVERT);
                     j = i;
                     v = 1;
                     while(j < i + 8 && j < shadowListLength)
                     {
                        shadow = this.shadowList[j];
                        if(!shadow.cameraInside)
                        {
                           this.device.setStencilReferenceValue(v,v,v);
                           shadow.renderVolume(this);
                        }
                        j++;
                        v <<= 1;
                     }
                     this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                     this.device.setCulling(Context3DTriangleFace.FRONT);
                     this.device.setStencilActions(Context3DTriangleFace.BACK,Context3DCompareMode.EQUAL);
                     j = i;
                     v = 1;
                     while(j < i + 8 && j < shadowListLength)
                     {
                        shadow = this.shadowList[j];
                        if(shadow.texture != lastTexture)
                        {
                           this.device.setTextureAt(0,shadow.texture);
                           lastTexture = shadow.texture;
                        }
                        if(!shadow.cameraInside)
                        {
                           this.device.setStencilReferenceValue(v,v,v);
                           shadow.renderReceivers(this);
                        }
                        else
                        {
                           this.device.setStencilActions(Context3DTriangleFace.BACK,Context3DCompareMode.ALWAYS);
                           shadow.renderReceivers(this);
                           this.device.setStencilActions(Context3DTriangleFace.BACK,Context3DCompareMode.EQUAL);
                        }
                        j++;
                        v <<= 1;
                     }
                     this.device.setTextureAt(0,null);
                     lastTexture = null;
                  }
                  this.device.setStencilActions();
                  this.device.setStencilReferenceValue(0);
               }
               this.device.setProgramConstantsFromVector(Context3DProgramType.VERTEX,13,this.correction,1);
               if(!this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0))
               {
                  this.device.setTextureAt(1,this.depthMap);
               }
               if(!this.view.constrained && this.deferredLighting && this.deferredLightingStrength > 0)
               {
                  this.device.setTextureAt(5,this.lightMap);
               }
               if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
               {
                  this.device.setTextureAt(2,this.shadowMap.map);
                  this.device.setTextureAt(3,this.shadowMap.noise);
               }
               this.device.setCulling(Context3DTriangleFace.FRONT);
               this.device.setDepthTest(true,Context3DCompareMode.LESS);
               for(i = 0; i < this.transparentOpaqueCount; i++)
               {
                  this.transparentFaceLists[this.transparentCount] = this.transparentOpaqueFaceLists[i];
                  this.transparentObjects[this.transparentCount] = this.transparentOpaqueObjects[i];
                  ++this.transparentCount;
               }
               this.transparentOpaqueCount = this.transparentCount - this.transparentOpaqueCount;
               for(lastBlendMode = ""; this.transparentCount > 0; )
               {
                  if(this.transparentCount == this.transparentOpaqueCount)
                  {
                     this.device.setDepthTest(false,Context3DCompareMode.LESS);
                  }
                  --this.transparentCount;
                  faceList = this.transparentFaceLists[this.transparentCount];
                  object = this.transparentObjects[this.transparentCount];
                  if(object.concatenatedBlendMode != lastBlendMode)
                  {
                     lastBlendMode = object.concatenatedBlendMode;
                     if(lastBlendMode == "add" || lastBlendMode == "screen")
                     {
                        this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE);
                     }
                     else
                     {
                        this.device.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
                     }
                  }
                  onTop = object.name == "title";
                  if(onTop)
                  {
                     this.device.setDepthTest(false,Context3DCompareMode.ALWAYS);
                  }
                  if(object.receivedShadowsCount == 0)
                  {
                     faceList.material.drawTransparent(this,faceList,object);
                  }
                  else
                  {
                     while(faceList != null)
                     {
                        next = faceList.processNext;
                        faceList.processNext = null;
                        lastNumTriangles = this.numTriangles;
                        faceList.material.drawTransparent(this,faceList,object);
                        lastNumTriangles = this.numTriangles - lastNumTriangles;
                        if(lastNumTriangles > 0)
                        {
                           if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
                           {
                              this.device.setTextureAt(2,null);
                              this.device.setTextureAt(3,null);
                           }
                           if(!this.view.constrained && this.deferredLighting && this.deferredLightingStrength > 0)
                           {
                              this.device.setTextureAt(5,null);
                           }
                           for(i = 0; i < object.receivedShadowsCount; i++)
                           {
                              shadow = object.receivedShadows[i];
                              shadow.renderFace(this,lastNumTriangles);
                           }
                           if(!this.view.constrained && (this.softTransparency && this.softTransparencyStrength > 0 || this.ssao && this.ssaoStrength > 0))
                           {
                              this.device.setTextureAt(1,this.depthMap);
                           }
                           else
                           {
                              this.device.setTextureAt(1,null);
                           }
                           if(!this.view.constrained && this.shadowMap != null && this.shadowMapStrength > 0)
                           {
                              this.device.setTextureAt(2,this.shadowMap.map);
                              this.device.setTextureAt(3,this.shadowMap.noise);
                           }
                           if(!this.view.constrained && this.deferredLighting && this.deferredLightingStrength > 0)
                           {
                              this.device.setTextureAt(5,this.lightMap);
                           }
                        }
                        faceList = next;
                     }
                  }
                  if(onTop)
                  {
                     this.device.setDepthTest(false,Context3DCompareMode.LESS);
                  }
               }
               this.device.setTextureAt(0,null);
               this.device.setTextureAt(1,null);
               this.device.setTextureAt(2,null);
               this.device.setTextureAt(3,null);
               this.device.setTextureAt(5,null);
               this.opaqueMaterials.length = 0;
               this.opaqueVertexBuffers.length = 0;
               this.opaqueIndexBuffers.length = 0;
               this.opaqueRanges.length = 0;
               this.opaqueObjects.length = 0;
               this.opaqueCount = 0;
               this.transparentFaceLists.length = 0;
               this.transparentObjects.length = 0;
               this.transparentCount = 0;
               this.transparentOpaqueFaceLists.length = 0;
               this.transparentOpaqueObjects.length = 0;
               this.transparentOpaqueCount = 0;
               this.decalFaceLists.length = 0;
               this.decalObjects.length = 0;
               this.decalCount = 0;
               this.depthObjects.length = 0;
               this.depthCount = 0;
               this.casterObjects.length = 0;
               this.casterCount = 0;
               this.omnies.length = 0;
               this.omniesCount = 0;
               this.spots.length = 0;
               this.spotsCount = 0;
               this.tubes.length = 0;
               this.tubesCount = 0;
               for each(atlas in this.shadowAtlases)
               {
                  if(atlas.shadowsCount > 0)
                  {
                     atlas.clear();
                  }
               }
               for(key in this.shadedTransparentObjects)
               {
                  shadedObject = key;
                  this.numShadows += shadedObject.receivedShadowsCount;
                  shadedObject.receivedShadows.length = 0;
                  shadedObject.receivedShadowsCount = 0;
                  delete this.shadedTransparentObjects[shadedObject];
               }
               this.receiversVertexBuffers = null;
               this.receiversIndexBuffers = null;
               this.deferredDestroy();
               this.clearOccluders();
               this.view.onRender(this);
               if(this.onRender != null)
               {
                  this.onRender();
               }
               this.view.present();
            }
            else
            {
               this.view.clearArea();
               if(this.onRender != null)
               {
                  this.onRender();
               }
               this.view.present();
            }
         }
      }
      
      public function lookAt(x:Number, y:Number, z:Number) : void
      {
         var dx:Number = x - this.x;
         var dy:Number = y - this.y;
         var dz:Number = z - this.z;
         rotationX = Math.atan2(dz,Math.sqrt(dx * dx + dy * dy)) - Math.PI / 2;
         rotationY = 0;
         rotationZ = -Math.atan2(dx,dy);
      }
      
      public function projectGlobal(point:Vector3D) : Vector3D
      {
         if(this.view == null)
         {
            throw new Error("It is necessary to have view set.");
         }
         this.viewSizeX = this.view._width * 0.5;
         this.viewSizeY = this.view._height * 0.5;
         this.focalLength = Math.sqrt(this.viewSizeX * this.viewSizeX + this.viewSizeY * this.viewSizeY) / Math.tan(this.fov * 0.5);
         this.composeCameraMatrix();
         for(var root:Object3D = this; root._parent != null; )
         {
            root = root._parent;
            tA.composeMatrixFromSource(root);
            appendMatrix(tA);
         }
         invertMatrix();
         var res:Vector3D = new Vector3D();
         res.x = ma * point.x + mb * point.y + mc * point.z + md;
         res.y = me * point.x + mf * point.y + mg * point.z + mh;
         res.z = mi * point.x + mj * point.y + mk * point.z + ml;
         res.x = res.x * this.viewSizeX / res.z + this.viewSizeX;
         res.y = res.y * this.viewSizeY / res.z + this.viewSizeY;
         return res;
      }
      
      public function calculateRay(origin:Vector3D, direction:Vector3D, viewX:Number, viewY:Number) : void
      {
         if(this.view == null)
         {
            throw new Error("It is necessary to have view set.");
         }
         this.viewSizeX = this.view._width * 0.5;
         this.viewSizeY = this.view._height * 0.5;
         this.focalLength = Math.sqrt(this.viewSizeX * this.viewSizeX + this.viewSizeY * this.viewSizeY) / Math.tan(this.fov * 0.5);
         viewX -= this.viewSizeX;
         viewY -= this.viewSizeY;
         var dx:Number = viewX * this.focalLength / this.viewSizeX;
         var dy:Number = viewY * this.focalLength / this.viewSizeY;
         var dz:Number = this.focalLength;
         var ox:Number = dx * this.nearClipping / this.focalLength;
         var oy:Number = dy * this.nearClipping / this.focalLength;
         var oz:Number = this.nearClipping;
         this.composeCameraMatrix();
         for(var root:Object3D = this; root._parent != null; )
         {
            root = root._parent;
            tA.composeMatrixFromSource(root);
            appendMatrix(tA);
         }
         origin.x = ma * ox + mb * oy + mc * oz + md;
         origin.y = me * ox + mf * oy + mg * oz + mh;
         origin.z = mi * ox + mj * oy + mk * oz + ml;
         direction.x = ma * dx + mb * dy + mc * dz;
         direction.y = me * dx + mf * dy + mg * dz;
         direction.z = mi * dx + mj * dy + mk * dz;
         var directionL:Number = 1 / Math.sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
         direction.x *= directionL;
         direction.y *= directionL;
         direction.z *= directionL;
      }
      
      override public function clone() : Object3D
      {
         var res:Camera3D = new Camera3D();
         res.clonePropertiesFrom(this);
         return res;
      }
      
      override protected function clonePropertiesFrom(source:Object3D) : void
      {
         var key:* = undefined;
         super.clonePropertiesFrom(source);
         var src:Camera3D = source as Camera3D;
         this.fov = src.fov;
         this.nearClipping = src.nearClipping;
         this.farClipping = src.farClipping;
         this.debug = src.debug;
         this.fogNear = src.fogNear;
         this.fogFar = src.fogFar;
         this.fogAlpha = src.fogAlpha;
         this.fogColor = src.fogColor;
         this.softTransparency = src.softTransparency;
         this.depthBufferScale = src.depthBufferScale;
         this.ssao = src.ssao;
         this.ssaoRadius = src.ssaoRadius;
         this.ssaoRange = src.ssaoRange;
         this.ssaoColor = src.ssaoColor;
         this.ssaoAlpha = src.ssaoAlpha;
         this.directionalLight = src.directionalLight;
         this.shadowMap = src.shadowMap;
         this.ambientColor = src.ambientColor;
         this.deferredLighting = src.deferredLighting;
         this.fogStrength = src.fogStrength;
         this.softTransparencyStrength = src.softTransparencyStrength;
         this.ssaoStrength = src.ssaoStrength;
         this.directionalLightStrength = src.directionalLightStrength;
         this.shadowMapStrength = src.shadowMapStrength;
         this.shadowsStrength = src.shadowsStrength;
         this.shadowsDistanceMultiplier = src.shadowsDistanceMultiplier;
         this.deferredLightingStrength = src.deferredLightingStrength;
         for(key in src.shadows)
         {
            this.shadows[key] = true;
         }
      }
      
      alternativa3d function addOpaque(material:Material, vertexBuffer:VertexBufferResource, indexBuffer:IndexBufferResource, firstIndex:int, numTriangles:int, object:Object3D) : void
      {
         this.opaqueMaterials[this.opaqueCount] = material;
         this.opaqueVertexBuffers[this.opaqueCount] = vertexBuffer;
         this.opaqueIndexBuffers[this.opaqueCount] = indexBuffer;
         this.opaqueRanges[this.opaqueCount] = firstIndex << 16 | numTriangles;
         this.opaqueObjects[this.opaqueCount] = object;
         ++this.opaqueCount;
      }
      
      alternativa3d function addTransparent(faceList:Face, object:Object3D) : void
      {
         this.transparentFaceLists[this.transparentCount] = faceList;
         this.transparentObjects[this.transparentCount] = object;
         ++this.transparentCount;
      }
      
      alternativa3d function addTransparentOpaque(faceList:Face, object:Object3D) : void
      {
         this.transparentOpaqueFaceLists[this.transparentOpaqueCount] = faceList;
         this.transparentOpaqueObjects[this.transparentOpaqueCount] = object;
         ++this.transparentOpaqueCount;
      }
      
      alternativa3d function addDecal(faceList:Face, object:Object3D) : void
      {
         this.decalFaceLists[this.decalCount] = faceList;
         this.decalObjects[this.decalCount] = object;
         ++this.decalCount;
      }
      
      alternativa3d function composeCameraMatrix() : void
      {
         var vx:Number = this.viewSizeX / this.focalLength;
         var vy:Number = this.viewSizeY / this.focalLength;
         var cosX:Number = Math.cos(rotationX);
         var sinX:Number = Math.sin(rotationX);
         var cosY:Number = Math.cos(rotationY);
         var sinY:Number = Math.sin(rotationY);
         var cosZ:Number = Math.cos(rotationZ);
         var sinZ:Number = Math.sin(rotationZ);
         var cosZsinY:Number = cosZ * sinY;
         var sinZsinY:Number = sinZ * sinY;
         var cosYscaleX:Number = cosY * scaleX;
         var sinXscaleY:Number = sinX * scaleY;
         var cosXscaleY:Number = cosX * scaleY;
         var cosXscaleZ:Number = cosX * scaleZ;
         var sinXscaleZ:Number = sinX * scaleZ;
         ma = cosZ * cosYscaleX * vx;
         mb = (cosZsinY * sinXscaleY - sinZ * cosXscaleY) * vy;
         mc = cosZsinY * cosXscaleZ + sinZ * sinXscaleZ;
         md = x;
         me = sinZ * cosYscaleX * vx;
         mf = (sinZsinY * sinXscaleY + cosZ * cosXscaleY) * vy;
         mg = sinZsinY * cosXscaleZ - cosZ * sinXscaleZ;
         mh = y;
         mi = -sinY * scaleX * vx;
         mj = cosY * sinXscaleY * vy;
         mk = cosY * cosXscaleZ;
         ml = z;
         var skewX:Number = this.view.offsetX / this.viewSizeX;
         var skewY:Number = this.view.offsetY / this.viewSizeY;
         mc -= ma * skewX + mb * skewY;
         mg -= me * skewX + mf * skewY;
         mk -= mi * skewX + mj * skewY;
      }
      
      public function addToDebug(debug:int, objectOrClass:*) : void
      {
         if(!this.debugSet[debug])
         {
            this.debugSet[debug] = new Dictionary();
         }
         this.debugSet[debug][objectOrClass] = true;
      }
      
      public function removeFromDebug(debug:int, objectOrClass:*) : void
      {
         var key:* = undefined;
         if(Boolean(this.debugSet[debug]))
         {
            delete this.debugSet[debug][objectOrClass];
            var _loc4_:int = 0;
            var _loc5_:* = this.debugSet[debug];
            for(key in _loc5_)
            {
            }
            if(!key)
            {
               delete this.debugSet[debug];
            }
         }
      }
      
      alternativa3d function checkInDebug(object:Object3D) : int
      {
         var objectClass:Class = null;
         var res:int = 0;
         for(var debug:int = 1; debug <= 512; )
         {
            if(Boolean(this.debugSet[debug]))
            {
               if(Boolean(this.debugSet[debug][Object3D]) || Boolean(this.debugSet[debug][object]))
               {
                  res |= debug;
               }
               else
               {
                  objectClass = getDefinitionByName(getQualifiedClassName(object)) as Class;
                  while(true)
                  {
                     if(objectClass == Object3D)
                     {
                        break;
                     }
                     if(Boolean(this.debugSet[debug][objectClass]))
                     {
                        res |= debug;
                        break;
                     }
                     objectClass = Class(getDefinitionByName(getQualifiedSuperclassName(objectClass)));
                  }
               }
            }
            debug <<= 1;
         }
         return res;
      }
      
      public function startTimer() : void
      {
         this.timer = getTimer();
      }
      
      public function stopTimer() : void
      {
         this.timeSum += getTimer() - this.timer;
         ++this.timeCount;
      }
      
      public function get diagram() : DisplayObject
      {
         return this._diagram;
      }
      
      public function get diagramAlign() : String
      {
         return this._diagramAlign;
      }
      
      public function set diagramAlign(value:String) : void
      {
         this._diagramAlign = value;
         this.resizeDiagram();
      }
      
      public function get diagramHorizontalMargin() : Number
      {
         return this._diagramHorizontalMargin;
      }
      
      public function set diagramHorizontalMargin(value:Number) : void
      {
         this._diagramHorizontalMargin = value;
         this.resizeDiagram();
      }
      
      public function get diagramVerticalMargin() : Number
      {
         return this._diagramVerticalMargin;
      }
      
      public function set diagramVerticalMargin(value:Number) : void
      {
         this._diagramVerticalMargin = value;
         this.resizeDiagram();
      }
      
      private function createDiagram() : Sprite
      {
         var diagram:Sprite = null;
         diagram = new Sprite();
         diagram.mouseEnabled = false;
         diagram.mouseChildren = false;
         diagram.addEventListener(Event.ADDED_TO_STAGE,function():void
         {
            while(diagram.numChildren > 0)
            {
               diagram.removeChildAt(0);
            }
            fpsTextField = new TextField();
            fpsTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421772);
            fpsTextField.autoSize = TextFieldAutoSize.LEFT;
            fpsTextField.text = "FPS:";
            fpsTextField.selectable = false;
            fpsTextField.x = -3;
            fpsTextField.y = -5;
            diagram.addChild(fpsTextField);
            fpsTextField = new TextField();
            fpsTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421772);
            fpsTextField.autoSize = TextFieldAutoSize.RIGHT;
            fpsTextField.text = Number(diagram.stage.frameRate).toFixed(2);
            fpsTextField.selectable = false;
            fpsTextField.x = -3;
            fpsTextField.y = -5;
            fpsTextField.width = 65;
            diagram.addChild(fpsTextField);
            timerTextField = new TextField();
            timerTextField.defaultTextFormat = new TextFormat("Tahoma",10,26367);
            timerTextField.autoSize = TextFieldAutoSize.LEFT;
            timerTextField.text = "MS:";
            timerTextField.selectable = false;
            timerTextField.x = -3;
            timerTextField.y = 4;
            diagram.addChild(timerTextField);
            timerTextField = new TextField();
            timerTextField.defaultTextFormat = new TextFormat("Tahoma",10,26367);
            timerTextField.autoSize = TextFieldAutoSize.RIGHT;
            timerTextField.text = "";
            timerTextField.selectable = false;
            timerTextField.x = -3;
            timerTextField.y = 4;
            timerTextField.width = 65;
            diagram.addChild(timerTextField);
            memoryTextField = new TextField();
            memoryTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421568);
            memoryTextField.autoSize = TextFieldAutoSize.LEFT;
            memoryTextField.text = "MEM:";
            memoryTextField.selectable = false;
            memoryTextField.x = -3;
            memoryTextField.y = 13;
            diagram.addChild(memoryTextField);
            memoryTextField = new TextField();
            memoryTextField.defaultTextFormat = new TextFormat("Tahoma",10,13421568);
            memoryTextField.autoSize = TextFieldAutoSize.RIGHT;
            memoryTextField.text = bytesToString(System.totalMemory);
            memoryTextField.selectable = false;
            memoryTextField.x = -3;
            memoryTextField.y = 13;
            memoryTextField.width = 65;
            diagram.addChild(memoryTextField);
            drawsTextField = new TextField();
            drawsTextField.defaultTextFormat = new TextFormat("Tahoma",10,52224);
            drawsTextField.autoSize = TextFieldAutoSize.LEFT;
            drawsTextField.text = "DRW:";
            drawsTextField.selectable = false;
            drawsTextField.x = -3;
            drawsTextField.y = 22;
            diagram.addChild(drawsTextField);
            drawsTextField = new TextField();
            drawsTextField.defaultTextFormat = new TextFormat("Tahoma",10,52224);
            drawsTextField.autoSize = TextFieldAutoSize.RIGHT;
            drawsTextField.text = "0";
            drawsTextField.selectable = false;
            drawsTextField.x = -3;
            drawsTextField.y = 22;
            drawsTextField.width = 52;
            diagram.addChild(drawsTextField);
            shadowsTextField = new TextField();
            shadowsTextField.defaultTextFormat = new TextFormat("Tahoma",10,16711731);
            shadowsTextField.autoSize = TextFieldAutoSize.LEFT;
            shadowsTextField.text = "SHD:";
            shadowsTextField.selectable = false;
            shadowsTextField.x = -3;
            shadowsTextField.y = 31;
            diagram.addChild(shadowsTextField);
            shadowsTextField = new TextField();
            shadowsTextField.defaultTextFormat = new TextFormat("Tahoma",10,16711731);
            shadowsTextField.autoSize = TextFieldAutoSize.RIGHT;
            shadowsTextField.text = "0";
            shadowsTextField.selectable = false;
            shadowsTextField.x = -3;
            shadowsTextField.y = 31;
            shadowsTextField.width = 52;
            diagram.addChild(shadowsTextField);
            trianglesTextField = new TextField();
            trianglesTextField.defaultTextFormat = new TextFormat("Tahoma",10,16737792);
            trianglesTextField.autoSize = TextFieldAutoSize.LEFT;
            trianglesTextField.text = "TRI:";
            trianglesTextField.selectable = false;
            trianglesTextField.x = -3;
            trianglesTextField.y = 40;
            diagram.addChild(trianglesTextField);
            trianglesTextField = new TextField();
            trianglesTextField.defaultTextFormat = new TextFormat("Tahoma",10,16737792);
            trianglesTextField.autoSize = TextFieldAutoSize.RIGHT;
            trianglesTextField.text = "0";
            trianglesTextField.selectable = false;
            trianglesTextField.x = -3;
            trianglesTextField.y = 40;
            trianglesTextField.width = 52;
            diagram.addChild(trianglesTextField);
            graph = new Bitmap(new BitmapData(60,40,true,553648127));
            rect = new Rectangle(0,0,1,40);
            graph.x = 0;
            graph.y = 54;
            diagram.addChild(graph);
            previousPeriodTime = getTimer();
            previousFrameTime = previousPeriodTime;
            fpsUpdateCounter = 0;
            maxMemory = 0;
            timerUpdateCounter = 0;
            timeSum = 0;
            timeCount = 0;
            diagram.stage.addEventListener(Event.ENTER_FRAME,updateDiagram,false,-1000);
            diagram.stage.addEventListener(Event.RESIZE,resizeDiagram,false,-1000);
            resizeDiagram();
         });
         diagram.addEventListener(Event.REMOVED_FROM_STAGE,function():void
         {
            while(diagram.numChildren > 0)
            {
               diagram.removeChildAt(0);
            }
            fpsTextField = null;
            memoryTextField = null;
            drawsTextField = null;
            shadowsTextField = null;
            trianglesTextField = null;
            timerTextField = null;
            graph.bitmapData.dispose();
            graph = null;
            rect = null;
            diagram.stage.removeEventListener(Event.ENTER_FRAME,updateDiagram);
            diagram.stage.removeEventListener(Event.RESIZE,resizeDiagram);
         });
         return diagram;
      }
      
      private function resizeDiagram(e:Event = null) : void
      {
         var coord:Point = null;
         if(this._diagram.stage != null)
         {
            coord = this._diagram.parent.globalToLocal(new Point());
            if(this._diagramAlign == StageAlign.TOP_LEFT || this._diagramAlign == StageAlign.LEFT || this._diagramAlign == StageAlign.BOTTOM_LEFT)
            {
               this._diagram.x = Math.round(coord.x + this._diagramHorizontalMargin);
            }
            if(this._diagramAlign == StageAlign.TOP || this._diagramAlign == StageAlign.BOTTOM)
            {
               this._diagram.x = Math.round(coord.x + this._diagram.stage.stageWidth / 2 - this.graph.width / 2);
            }
            if(this._diagramAlign == StageAlign.TOP_RIGHT || this._diagramAlign == StageAlign.RIGHT || this._diagramAlign == StageAlign.BOTTOM_RIGHT)
            {
               this._diagram.x = Math.round(coord.x + this._diagram.stage.stageWidth - this._diagramHorizontalMargin - this.graph.width);
            }
            if(this._diagramAlign == StageAlign.TOP_LEFT || this._diagramAlign == StageAlign.TOP || this._diagramAlign == StageAlign.TOP_RIGHT)
            {
               this._diagram.y = Math.round(coord.y + this._diagramVerticalMargin);
            }
            if(this._diagramAlign == StageAlign.LEFT || this._diagramAlign == StageAlign.RIGHT)
            {
               this._diagram.y = Math.round(coord.y + this._diagram.stage.stageHeight / 2 - (this.graph.y + this.graph.height) / 2);
            }
            if(this._diagramAlign == StageAlign.BOTTOM_LEFT || this._diagramAlign == StageAlign.BOTTOM || this._diagramAlign == StageAlign.BOTTOM_RIGHT)
            {
               this._diagram.y = Math.round(coord.y + this._diagram.stage.stageHeight - this._diagramVerticalMargin - this.graph.y - this.graph.height);
            }
         }
      }
      
      private function updateDiagram(e:Event) : void
      {
         var value:Number = NaN;
         var mod:int = 0;
         var modStr:String = null;
         var time:int = getTimer();
         var stageFrameRate:int = this._diagram.stage.frameRate;
         if(++this.fpsUpdateCounter == this.fpsUpdatePeriod)
         {
            value = 1000 * this.fpsUpdatePeriod / (time - this.previousPeriodTime);
            if(value > stageFrameRate)
            {
               value = stageFrameRate;
            }
            mod = value * 100 % 100;
            modStr = mod >= 10 ? String(mod) : (mod > 0 ? "0" + String(mod) : "00");
            this.fpsTextField.text = int(value) + "." + modStr;
            this.previousPeriodTime = time;
            this.fpsUpdateCounter = 0;
         }
         value = 1000 / (time - this.previousFrameTime);
         if(value > stageFrameRate)
         {
            value = stageFrameRate;
         }
         this.graph.bitmapData.scroll(1,0);
         this.graph.bitmapData.fillRect(this.rect,553648127);
         this.graph.bitmapData.setPixel32(0,40 * (1 - value / stageFrameRate),4291611852);
         this.previousFrameTime = time;
         if(++this.timerUpdateCounter == this.timerUpdatePeriod)
         {
            if(this.timeCount > 0)
            {
               value = this.timeSum / this.timeCount;
               mod = value * 100 % 100;
               modStr = mod >= 10 ? String(mod) : (mod > 0 ? "0" + String(mod) : "00");
               this.timerTextField.text = int(value) + "." + modStr;
            }
            else
            {
               this.timerTextField.text = "";
            }
            this.timerUpdateCounter = 0;
            this.timeSum = 0;
            this.timeCount = 0;
         }
         var memory:int = int(System.totalMemory);
         value = memory / 1048576;
         mod = value * 100 % 100;
         modStr = mod >= 10 ? String(mod) : (mod > 0 ? "0" + String(mod) : "00");
         this.memoryTextField.text = int(value) + "." + modStr;
         if(memory > this.maxMemory)
         {
            this.maxMemory = memory;
         }
         this.graph.bitmapData.setPixel32(0,40 * (1 - memory / this.maxMemory),4291611648);
         this.drawsTextField.text = String(this.numDraws);
         this.shadowsTextField.text = String(this.numShadows);
         this.trianglesTextField.text = String(this.numTriangles);
      }
      
      private function bytesToString(bytes:int) : String
      {
         if(bytes < 1024)
         {
            return bytes + "b";
         }
         if(bytes < 10240)
         {
            return (bytes / 1024).toFixed(2) + "kb";
         }
         if(bytes < 102400)
         {
            return (bytes / 1024).toFixed(1) + "kb";
         }
         if(bytes < 1048576)
         {
            return (bytes >> 10) + "kb";
         }
         if(bytes < 10485760)
         {
            return (bytes / 1048576).toFixed(2);
         }
         if(bytes < 104857600)
         {
            return (bytes / 1048576).toFixed(1);
         }
         return String(bytes >> 20);
      }
      
      alternativa3d function deferredDestroy() : void
      {
         var w:Wrapper = null;
         var lw:Wrapper = null;
         for(var face:Face = this.firstFace.next; face != null; face = face.next)
         {
            w = face.wrapper;
            if(w != null)
            {
               lw = null;
               while(w != null)
               {
                  w.vertex = null;
                  lw = w;
                  w = w.next;
               }
               this.lastWrapper.next = face.wrapper;
               this.lastWrapper = lw;
            }
            face.material = null;
            face.wrapper = null;
         }
         if(this.firstFace != this.lastFace)
         {
            this.lastFace.next = Face.collector;
            Face.collector = this.firstFace.next;
            this.firstFace.next = null;
            this.lastFace = this.firstFace;
         }
         if(this.firstWrapper != this.lastWrapper)
         {
            this.lastWrapper.next = Wrapper.collector;
            Wrapper.collector = this.firstWrapper.next;
            this.firstWrapper.next = null;
            this.lastWrapper = this.firstWrapper;
         }
         if(this.firstVertex != this.lastVertex)
         {
            this.lastVertex.next = Vertex.collector;
            Vertex.collector = this.firstVertex.next;
            this.firstVertex.next = null;
            this.lastVertex = this.firstVertex;
         }
      }
      
      alternativa3d function clearOccluders() : void
      {
         var first:Vertex = null;
         var last:Vertex = null;
         for(var i:int = 0; i < this.numOccluders; i++)
         {
            first = this.occluders[i];
            for(last = first; last.next != null; )
            {
               last = last.next;
            }
            last.next = Vertex.collector;
            Vertex.collector = first;
            this.occluders[i] = null;
         }
         this.numOccluders = 0;
      }
      
      alternativa3d function sortByAverageZ(list:Face) : Face
      {
         var num:int = 0;
         var sum:Number = NaN;
         var wrapper:Wrapper = null;
         var left:Face = list;
         var right:Face = list.processNext;
         while(right != null && right.processNext != null)
         {
            list = list.processNext;
            right = right.processNext.processNext;
         }
         right = list.processNext;
         list.processNext = null;
         if(left.processNext != null)
         {
            left = this.sortByAverageZ(left);
         }
         else
         {
            num = 0;
            sum = 0;
            for(wrapper = left.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               num++;
               sum += wrapper.vertex.cameraZ;
            }
            left.distance = sum / num;
         }
         if(right.processNext != null)
         {
            right = this.sortByAverageZ(right);
         }
         else
         {
            num = 0;
            sum = 0;
            for(wrapper = right.wrapper; wrapper != null; wrapper = wrapper.next)
            {
               num++;
               sum += wrapper.vertex.cameraZ;
            }
            right.distance = sum / num;
         }
         var flag:Boolean = left.distance > right.distance;
         if(flag)
         {
            list = left;
            left = left.processNext;
         }
         else
         {
            list = right;
            right = right.processNext;
         }
         for(var last:Face = list; true; )
         {
            if(left == null)
            {
               last.processNext = right;
               return list;
            }
            if(right == null)
            {
               last.processNext = left;
               return list;
            }
            if(flag)
            {
               if(left.distance > right.distance)
               {
                  last = left;
                  left = left.processNext;
               }
               else
               {
                  last.processNext = right;
                  last = right;
                  right = right.processNext;
                  flag = false;
               }
            }
            else if(right.distance > left.distance)
            {
               last = right;
               right = right.processNext;
            }
            else
            {
               last.processNext = left;
               last = left;
               left = left.processNext;
               flag = true;
            }
         }
         return null;
      }
      
      alternativa3d function sortByDynamicBSP(list:Face, threshold:Number, result:Face = null) : Face
      {
         var w:Wrapper = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var v:Vertex = null;
         var negativeFirst:Face = null;
         var negativeLast:Face = null;
         var positiveFirst:Face = null;
         var positiveLast:Face = null;
         var next:Face = null;
         var acx:Number = NaN;
         var acy:Number = NaN;
         var acz:Number = NaN;
         var nx:Number = NaN;
         var ny:Number = NaN;
         var nz:Number = NaN;
         var nl:Number = NaN;
         var ao:Number = NaN;
         var bo:Number = NaN;
         var co:Number = NaN;
         var behind:Boolean = false;
         var infront:Boolean = false;
         var vo:Number = NaN;
         var negative:Face = null;
         var positive:Face = null;
         var wNegative:Wrapper = null;
         var wPositive:Wrapper = null;
         var wNew:Wrapper = null;
         var interpolateNormals:Boolean = false;
         var t:Number = NaN;
         var splitter:Face = list;
         list = splitter.processNext;
         w = splitter.wrapper;
         a = w.vertex;
         w = w.next;
         b = w.vertex;
         var ax:Number = a.cameraX;
         var ay:Number = a.cameraY;
         var az:Number = a.cameraZ;
         var abx:Number = b.cameraX - ax;
         var aby:Number = b.cameraY - ay;
         var abz:Number = b.cameraZ - az;
         var normalX:Number = 0;
         var normalY:Number = 0;
         var normalZ:Number = 1;
         var offset:Number = az;
         var length:Number = 0;
         for(w = w.next; w != null; w = w.next)
         {
            v = w.vertex;
            acx = v.cameraX - ax;
            acy = v.cameraY - ay;
            acz = v.cameraZ - az;
            nx = acz * aby - acy * abz;
            ny = acx * abz - acz * abx;
            nz = acy * abx - acx * aby;
            nl = nx * nx + ny * ny + nz * nz;
            if(nl > threshold)
            {
               nl = 1 / Math.sqrt(nl);
               normalX = nx * nl;
               normalY = ny * nl;
               normalZ = nz * nl;
               offset = ax * normalX + ay * normalY + az * normalZ;
               break;
            }
            if(nl > length)
            {
               nl = 1 / Math.sqrt(nl);
               normalX = nx * nl;
               normalY = ny * nl;
               normalZ = nz * nl;
               offset = ax * normalX + ay * normalY + az * normalZ;
               length = nl;
            }
         }
         var offsetMin:Number = offset - threshold;
         var offsetMax:Number = offset + threshold;
         var splitterLast:Face = splitter;
         for(var face:Face = list; face != null; )
         {
            next = face.processNext;
            w = face.wrapper;
            a = w.vertex;
            w = w.next;
            b = w.vertex;
            w = w.next;
            c = w.vertex;
            w = w.next;
            ao = a.cameraX * normalX + a.cameraY * normalY + a.cameraZ * normalZ;
            bo = b.cameraX * normalX + b.cameraY * normalY + b.cameraZ * normalZ;
            co = c.cameraX * normalX + c.cameraY * normalY + c.cameraZ * normalZ;
            behind = ao < offsetMin || bo < offsetMin || co < offsetMin;
            for(infront = ao > offsetMax || bo > offsetMax || co > offsetMax; w != null; )
            {
               v = w.vertex;
               vo = v.cameraX * normalX + v.cameraY * normalY + v.cameraZ * normalZ;
               if(vo < offsetMin)
               {
                  behind = true;
               }
               else if(vo > offsetMax)
               {
                  infront = true;
               }
               v.offset = vo;
               w = w.next;
            }
            if(!behind)
            {
               if(!infront)
               {
                  splitterLast.processNext = face;
                  splitterLast = face;
               }
               else
               {
                  if(positiveFirst != null)
                  {
                     positiveLast.processNext = face;
                  }
                  else
                  {
                     positiveFirst = face;
                  }
                  positiveLast = face;
               }
            }
            else if(!infront)
            {
               if(negativeFirst != null)
               {
                  negativeLast.processNext = face;
               }
               else
               {
                  negativeFirst = face;
               }
               negativeLast = face;
            }
            else
            {
               a.offset = ao;
               b.offset = bo;
               c.offset = co;
               negative = face.create();
               negative.material = face.material;
               this.lastFace.next = negative;
               this.lastFace = negative;
               positive = face.create();
               positive.material = face.material;
               this.lastFace.next = positive;
               this.lastFace = positive;
               wNegative = null;
               wPositive = null;
               for(w = face.wrapper.next.next; w.next != null; )
               {
                  w = w.next;
               }
               a = w.vertex;
               ao = a.offset;
               interpolateNormals = face.material != null && face.material.useVerticesNormals;
               for(w = face.wrapper; w != null; w = w.next)
               {
                  b = w.vertex;
                  bo = b.offset;
                  if(ao < offsetMin && bo > offsetMax || ao > offsetMax && bo < offsetMin)
                  {
                     t = (offset - ao) / (bo - ao);
                     v = b.create();
                     this.lastVertex.next = v;
                     this.lastVertex = v;
                     v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                     v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                     v.cameraZ = a.cameraZ + (b.cameraZ - a.cameraZ) * t;
                     v.u = a.u + (b.u - a.u) * t;
                     v.v = a.v + (b.v - a.v) * t;
                     if(interpolateNormals)
                     {
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                        v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                        v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                     }
                     wNew = w.create();
                     wNew.vertex = v;
                     if(wNegative != null)
                     {
                        wNegative.next = wNew;
                     }
                     else
                     {
                        negative.wrapper = wNew;
                     }
                     wNegative = wNew;
                     wNew = w.create();
                     wNew.vertex = v;
                     if(wPositive != null)
                     {
                        wPositive.next = wNew;
                     }
                     else
                     {
                        positive.wrapper = wNew;
                     }
                     wPositive = wNew;
                  }
                  if(bo <= offsetMax)
                  {
                     wNew = w.create();
                     wNew.vertex = b;
                     if(wNegative != null)
                     {
                        wNegative.next = wNew;
                     }
                     else
                     {
                        negative.wrapper = wNew;
                     }
                     wNegative = wNew;
                  }
                  if(bo >= offsetMin)
                  {
                     wNew = w.create();
                     wNew.vertex = b;
                     if(wPositive != null)
                     {
                        wPositive.next = wNew;
                     }
                     else
                     {
                        positive.wrapper = wNew;
                     }
                     wPositive = wNew;
                  }
                  a = b;
                  ao = bo;
               }
               if(negativeFirst != null)
               {
                  negativeLast.processNext = negative;
               }
               else
               {
                  negativeFirst = negative;
               }
               negativeLast = negative;
               if(positiveFirst != null)
               {
                  positiveLast.processNext = positive;
               }
               else
               {
                  positiveFirst = positive;
               }
               positiveLast = positive;
               face.processNext = null;
            }
            face = next;
         }
         if(positiveFirst != null)
         {
            positiveLast.processNext = null;
            if(positiveFirst.processNext != null)
            {
               result = this.sortByDynamicBSP(positiveFirst,threshold,result);
            }
            else
            {
               positiveFirst.processNext = result;
               result = positiveFirst;
            }
         }
         splitterLast.processNext = result;
         result = splitter;
         if(negativeFirst != null)
         {
            negativeLast.processNext = null;
            if(negativeFirst.processNext != null)
            {
               result = this.sortByDynamicBSP(negativeFirst,threshold,result);
            }
            else
            {
               negativeFirst.processNext = result;
               result = negativeFirst;
            }
         }
         return result;
      }
      
      alternativa3d function cull(list:Face, culling:int) : Face
      {
         var first:Face = null;
         var last:Face = null;
         var next:Face = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var d:Wrapper = null;
         var v:Vertex = null;
         var w:Wrapper = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         var c1:Boolean = (culling & 1) > 0;
         var c2:Boolean = (culling & 2) > 0;
         var c4:Boolean = (culling & 4) > 0;
         var c8:Boolean = (culling & 8) > 0;
         var c16:Boolean = (culling & 0x10) > 0;
         var c32:Boolean = (culling & 0x20) > 0;
         var near:Number = this.nearClipping;
         var far:Number = this.farClipping;
         var needX:Boolean = c4 || c8;
         var needY:Boolean = c16 || c32;
         loop0:
         for(var face:Face = list; face != null; face = next)
         {
            next = face.processNext;
            d = face.wrapper;
            a = d.vertex;
            d = d.next;
            b = d.vertex;
            d = d.next;
            c = d.vertex;
            d = d.next;
            if(needX)
            {
               ax = a.cameraX;
               bx = b.cameraX;
               cx = c.cameraX;
            }
            if(needY)
            {
               ay = a.cameraY;
               by = b.cameraY;
               cy = c.cameraY;
            }
            az = a.cameraZ;
            bz = b.cameraZ;
            cz = c.cameraZ;
            if(c1)
            {
               if(az <= near || bz <= near || cz <= near)
               {
                  face.processNext = null;
               }
               else
               {
                  w = d;
                  while(true)
                  {
                     if(w != null)
                     {
                        if(w.vertex.cameraZ > near)
                        {
                           continue;
                        }
                     }
                     if(w != null)
                     {
                        face.processNext = null;
                        continue loop0;
                     }
                     w = w.next;
                  }
               }
               continue;
            }
            if(c2 && az >= far && bz >= far && cz >= far)
            {
               w = d;
               while(true)
               {
                  if(w != null)
                  {
                     if(w.vertex.cameraZ >= far)
                     {
                        continue;
                     }
                  }
                  if(w == null)
                  {
                     face.processNext = null;
                     continue loop0;
                  }
                  w = w.next;
               }
               continue;
            }
            if(c4 && az <= -ax && bz <= -bx && cz <= -cx)
            {
               w = d;
               while(true)
               {
                  if(w != null)
                  {
                     v = w.vertex;
                     if(-v.cameraX >= v.cameraZ)
                     {
                        continue;
                     }
                  }
                  if(w == null)
                  {
                     face.processNext = null;
                     continue loop0;
                  }
                  w = w.next;
               }
               continue;
            }
            if(c8 && az <= ax && bz <= bx && cz <= cx)
            {
               w = d;
               while(true)
               {
                  if(w != null)
                  {
                     v = w.vertex;
                     if(v.cameraX >= v.cameraZ)
                     {
                        continue;
                     }
                  }
                  if(w == null)
                  {
                     face.processNext = null;
                     continue loop0;
                  }
                  w = w.next;
               }
               continue;
            }
            if(c16 && az <= -ay && bz <= -by && cz <= -cy)
            {
               w = d;
               while(true)
               {
                  if(w != null)
                  {
                     v = w.vertex;
                     if(-v.cameraY >= v.cameraZ)
                     {
                        continue;
                     }
                  }
                  if(w == null)
                  {
                     face.processNext = null;
                     continue loop0;
                  }
                  w = w.next;
               }
               continue;
            }
            if(c32 && az <= ay && bz <= by && cz <= cy)
            {
               w = d;
               while(true)
               {
                  if(w != null)
                  {
                     v = w.vertex;
                     if(v.cameraY >= v.cameraZ)
                     {
                        continue;
                     }
                  }
                  if(w == null)
                  {
                     face.processNext = null;
                     continue loop0;
                  }
                  w = w.next;
               }
               continue;
            }
            if(first != null)
            {
               last.processNext = face;
            }
            else
            {
               first = face;
            }
            last = face;
         }
         if(last != null)
         {
            last.processNext = null;
         }
         return first;
      }
      
      alternativa3d function clip(list:Face, culling:int) : Face
      {
         var first:Face = null;
         var last:Face = null;
         var next:Face = null;
         var a:Vertex = null;
         var b:Vertex = null;
         var c:Vertex = null;
         var d:Wrapper = null;
         var v:Vertex = null;
         var w:Wrapper = null;
         var wFirst:Wrapper = null;
         var wLast:Wrapper = null;
         var wNext:Wrapper = null;
         var wNew:Wrapper = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         var cx:Number = NaN;
         var cy:Number = NaN;
         var cz:Number = NaN;
         var c1:Boolean = false;
         var c2:Boolean = false;
         var c4:Boolean = false;
         var c8:Boolean = false;
         var c16:Boolean = false;
         var c32:Boolean = false;
         var near:Number = NaN;
         var far:Number = NaN;
         var needX:Boolean = false;
         var needY:Boolean = false;
         var faceCulling:int = 0;
         var t:Number = NaN;
         var face:Face = null;
         var interpolateNormals:Boolean = false;
         var newFace:Face = null;
         c1 = (culling & 1) > 0;
         c2 = (culling & 2) > 0;
         c4 = (culling & 4) > 0;
         c8 = (culling & 8) > 0;
         c16 = (culling & 0x10) > 0;
         c32 = (culling & 0x20) > 0;
         near = this.nearClipping;
         far = this.farClipping;
         needX = c4 || c8;
         needY = c16 || c32;
         loop0:
         for(face = list; face != null; face = next)
         {
            next = face.processNext;
            d = face.wrapper;
            a = d.vertex;
            d = d.next;
            b = d.vertex;
            d = d.next;
            c = d.vertex;
            d = d.next;
            if(needX)
            {
               ax = a.cameraX;
               bx = b.cameraX;
               cx = c.cameraX;
            }
            if(needY)
            {
               ay = a.cameraY;
               by = b.cameraY;
               cy = c.cameraY;
            }
            az = a.cameraZ;
            bz = b.cameraZ;
            cz = c.cameraZ;
            faceCulling = 0;
            if(c1)
            {
               if(az <= near && bz <= near && cz <= near)
               {
                  w = d;
                  while(true)
                  {
                     if(w != null)
                     {
                        if(w.vertex.cameraZ <= near)
                        {
                           continue;
                        }
                        faceCulling |= 1;
                     }
                     if(w == null)
                     {
                        face.processNext = null;
                        continue loop0;
                     }
                     w = w.next;
                  }
                  continue;
               }
               if(az > near && bz > near && cz > near)
               {
                  for(w = d; w != null; )
                  {
                     if(w.vertex.cameraZ <= near)
                     {
                        faceCulling |= 1;
                        break;
                     }
                     w = w.next;
                  }
               }
               else
               {
                  faceCulling |= 1;
               }
            }
            if(c2)
            {
               if(az >= far && bz >= far && cz >= far)
               {
                  w = d;
                  while(true)
                  {
                     if(w != null)
                     {
                        if(w.vertex.cameraZ >= far)
                        {
                           continue;
                        }
                        faceCulling |= 2;
                     }
                     if(w == null)
                     {
                        face.processNext = null;
                        continue loop0;
                     }
                     w = w.next;
                  }
                  continue;
               }
               if(az < far && bz < far && cz < far)
               {
                  for(w = d; w != null; )
                  {
                     if(w.vertex.cameraZ >= far)
                     {
                        faceCulling |= 2;
                        break;
                     }
                     w = w.next;
                  }
               }
               else
               {
                  faceCulling |= 2;
               }
            }
            if(c4)
            {
               if(az <= -ax && bz <= -bx && cz <= -cx)
               {
                  w = d;
                  while(true)
                  {
                     if(w != null)
                     {
                        v = w.vertex;
                        if(-v.cameraX >= v.cameraZ)
                        {
                           continue;
                        }
                        faceCulling |= 4;
                     }
                     if(w == null)
                     {
                        face.processNext = null;
                        continue loop0;
                     }
                     w = w.next;
                  }
                  continue;
               }
               if(az > -ax && bz > -bx && cz > -cx)
               {
                  for(w = d; w != null; )
                  {
                     v = w.vertex;
                     if(-v.cameraX >= v.cameraZ)
                     {
                        faceCulling |= 4;
                        break;
                     }
                     w = w.next;
                  }
               }
               else
               {
                  faceCulling |= 4;
               }
            }
            if(c8)
            {
               if(az <= ax && bz <= bx && cz <= cx)
               {
                  w = d;
                  while(true)
                  {
                     if(w != null)
                     {
                        v = w.vertex;
                        if(v.cameraX >= v.cameraZ)
                        {
                           continue;
                        }
                        faceCulling |= 8;
                     }
                     if(w == null)
                     {
                        face.processNext = null;
                        continue loop0;
                     }
                     w = w.next;
                  }
                  continue;
               }
               if(az > ax && bz > bx && cz > cx)
               {
                  for(w = d; w != null; )
                  {
                     v = w.vertex;
                     if(v.cameraX >= v.cameraZ)
                     {
                        faceCulling |= 8;
                        break;
                     }
                     w = w.next;
                  }
               }
               else
               {
                  faceCulling |= 8;
               }
            }
            if(c16)
            {
               if(az <= -ay && bz <= -by && cz <= -cy)
               {
                  w = d;
                  while(true)
                  {
                     if(w != null)
                     {
                        v = w.vertex;
                        if(-v.cameraY >= v.cameraZ)
                        {
                           continue;
                        }
                        faceCulling |= 16;
                     }
                     if(w == null)
                     {
                        face.processNext = null;
                        continue loop0;
                     }
                     w = w.next;
                  }
                  continue;
               }
               if(az > -ay && bz > -by && cz > -cy)
               {
                  for(w = d; w != null; )
                  {
                     v = w.vertex;
                     if(-v.cameraY >= v.cameraZ)
                     {
                        faceCulling |= 16;
                        break;
                     }
                     w = w.next;
                  }
               }
               else
               {
                  faceCulling |= 16;
               }
            }
            if(c32)
            {
               if(az <= ay && bz <= by && cz <= cy)
               {
                  w = d;
                  while(true)
                  {
                     if(w != null)
                     {
                        v = w.vertex;
                        if(v.cameraY >= v.cameraZ)
                        {
                           continue;
                        }
                        faceCulling |= 32;
                     }
                     if(w == null)
                     {
                        face.processNext = null;
                        continue loop0;
                     }
                     w = w.next;
                  }
                  continue;
               }
               if(az > ay && bz > by && cz > cy)
               {
                  for(w = d; w != null; )
                  {
                     v = w.vertex;
                     if(v.cameraY >= v.cameraZ)
                     {
                        faceCulling |= 32;
                        break;
                     }
                     w = w.next;
                  }
               }
               else
               {
                  faceCulling |= 32;
               }
            }
            if(faceCulling > 0)
            {
               interpolateNormals = face.material != null && face.material.useVerticesNormals;
               wFirst = null;
               wLast = null;
               for(w = face.wrapper; w != null; )
               {
                  wNew = w.create();
                  wNew.vertex = w.vertex;
                  if(wFirst != null)
                  {
                     wLast.next = wNew;
                  }
                  else
                  {
                     wFirst = wNew;
                  }
                  wLast = wNew;
                  w = w.next;
               }
               if(Boolean(faceCulling & 1))
               {
                  a = wLast.vertex;
                  az = a.cameraZ;
                  w = wFirst;
                  wFirst = null;
                  wLast = null;
                  while(w != null)
                  {
                     wNext = w.next;
                     b = w.vertex;
                     bz = b.cameraZ;
                     if(bz > near && az <= near || bz <= near && az > near)
                     {
                        t = (near - az) / (bz - az);
                        v = b.create();
                        this.lastVertex.next = v;
                        this.lastVertex = v;
                        v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                        v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                        v.cameraZ = az + (bz - az) * t;
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        if(interpolateNormals)
                        {
                           v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                           v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                           v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                        }
                        wNew = w.create();
                        wNew.vertex = v;
                        if(wFirst != null)
                        {
                           wLast.next = wNew;
                        }
                        else
                        {
                           wFirst = wNew;
                        }
                        wLast = wNew;
                     }
                     if(bz > near)
                     {
                        if(wFirst != null)
                        {
                           wLast.next = w;
                        }
                        else
                        {
                           wFirst = w;
                        }
                        wLast = w;
                        w.next = null;
                     }
                     else
                     {
                        w.vertex = null;
                        w.next = Wrapper.collector;
                        Wrapper.collector = w;
                     }
                     a = b;
                     az = bz;
                     w = wNext;
                  }
                  if(wFirst == null)
                  {
                     face.processNext = null;
                     continue;
                  }
               }
               if(Boolean(faceCulling & 2))
               {
                  a = wLast.vertex;
                  az = a.cameraZ;
                  w = wFirst;
                  wFirst = null;
                  wLast = null;
                  while(w != null)
                  {
                     wNext = w.next;
                     b = w.vertex;
                     bz = b.cameraZ;
                     if(bz < far && az >= far || bz >= far && az < far)
                     {
                        t = (far - az) / (bz - az);
                        v = b.create();
                        this.lastVertex.next = v;
                        this.lastVertex = v;
                        v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                        v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                        v.cameraZ = az + (bz - az) * t;
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        if(interpolateNormals)
                        {
                           v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                           v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                           v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                        }
                        wNew = w.create();
                        wNew.vertex = v;
                        if(wFirst != null)
                        {
                           wLast.next = wNew;
                        }
                        else
                        {
                           wFirst = wNew;
                        }
                        wLast = wNew;
                     }
                     if(bz < far)
                     {
                        if(wFirst != null)
                        {
                           wLast.next = w;
                        }
                        else
                        {
                           wFirst = w;
                        }
                        wLast = w;
                        w.next = null;
                     }
                     else
                     {
                        w.vertex = null;
                        w.next = Wrapper.collector;
                        Wrapper.collector = w;
                     }
                     a = b;
                     az = bz;
                     w = wNext;
                  }
                  if(wFirst == null)
                  {
                     face.processNext = null;
                     continue;
                  }
               }
               if(Boolean(faceCulling & 4))
               {
                  a = wLast.vertex;
                  ax = a.cameraX;
                  az = a.cameraZ;
                  w = wFirst;
                  wFirst = null;
                  wLast = null;
                  while(w != null)
                  {
                     wNext = w.next;
                     b = w.vertex;
                     bx = b.cameraX;
                     bz = b.cameraZ;
                     if(bz > -bx && az <= -ax || bz <= -bx && az > -ax)
                     {
                        t = (ax + az) / (ax + az - bx - bz);
                        v = b.create();
                        this.lastVertex.next = v;
                        this.lastVertex = v;
                        v.cameraX = ax + (bx - ax) * t;
                        v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                        v.cameraZ = az + (bz - az) * t;
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        if(interpolateNormals)
                        {
                           v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                           v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                           v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                        }
                        wNew = w.create();
                        wNew.vertex = v;
                        if(wFirst != null)
                        {
                           wLast.next = wNew;
                        }
                        else
                        {
                           wFirst = wNew;
                        }
                        wLast = wNew;
                     }
                     if(bz > -bx)
                     {
                        if(wFirst != null)
                        {
                           wLast.next = w;
                        }
                        else
                        {
                           wFirst = w;
                        }
                        wLast = w;
                        w.next = null;
                     }
                     else
                     {
                        w.vertex = null;
                        w.next = Wrapper.collector;
                        Wrapper.collector = w;
                     }
                     a = b;
                     ax = bx;
                     az = bz;
                     w = wNext;
                  }
                  if(wFirst == null)
                  {
                     face.processNext = null;
                     continue;
                  }
               }
               if(Boolean(faceCulling & 8))
               {
                  a = wLast.vertex;
                  ax = a.cameraX;
                  az = a.cameraZ;
                  w = wFirst;
                  wFirst = null;
                  wLast = null;
                  while(w != null)
                  {
                     wNext = w.next;
                     b = w.vertex;
                     bx = b.cameraX;
                     bz = b.cameraZ;
                     if(bz > bx && az <= ax || bz <= bx && az > ax)
                     {
                        t = (az - ax) / (az - ax + bx - bz);
                        v = b.create();
                        this.lastVertex.next = v;
                        this.lastVertex = v;
                        v.cameraX = ax + (bx - ax) * t;
                        v.cameraY = a.cameraY + (b.cameraY - a.cameraY) * t;
                        v.cameraZ = az + (bz - az) * t;
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        if(interpolateNormals)
                        {
                           v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                           v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                           v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                        }
                        wNew = w.create();
                        wNew.vertex = v;
                        if(wFirst != null)
                        {
                           wLast.next = wNew;
                        }
                        else
                        {
                           wFirst = wNew;
                        }
                        wLast = wNew;
                     }
                     if(bz > bx)
                     {
                        if(wFirst != null)
                        {
                           wLast.next = w;
                        }
                        else
                        {
                           wFirst = w;
                        }
                        wLast = w;
                        w.next = null;
                     }
                     else
                     {
                        w.vertex = null;
                        w.next = Wrapper.collector;
                        Wrapper.collector = w;
                     }
                     a = b;
                     ax = bx;
                     az = bz;
                     w = wNext;
                  }
                  if(wFirst == null)
                  {
                     face.processNext = null;
                     continue;
                  }
               }
               if(Boolean(faceCulling & 0x10))
               {
                  a = wLast.vertex;
                  ay = a.cameraY;
                  az = a.cameraZ;
                  w = wFirst;
                  wFirst = null;
                  wLast = null;
                  while(w != null)
                  {
                     wNext = w.next;
                     b = w.vertex;
                     by = b.cameraY;
                     bz = b.cameraZ;
                     if(bz > -by && az <= -ay || bz <= -by && az > -ay)
                     {
                        t = (ay + az) / (ay + az - by - bz);
                        v = b.create();
                        this.lastVertex.next = v;
                        this.lastVertex = v;
                        v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                        v.cameraY = ay + (by - ay) * t;
                        v.cameraZ = az + (bz - az) * t;
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        if(interpolateNormals)
                        {
                           v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                           v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                           v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                        }
                        wNew = w.create();
                        wNew.vertex = v;
                        if(wFirst != null)
                        {
                           wLast.next = wNew;
                        }
                        else
                        {
                           wFirst = wNew;
                        }
                        wLast = wNew;
                     }
                     if(bz > -by)
                     {
                        if(wFirst != null)
                        {
                           wLast.next = w;
                        }
                        else
                        {
                           wFirst = w;
                        }
                        wLast = w;
                        w.next = null;
                     }
                     else
                     {
                        w.vertex = null;
                        w.next = Wrapper.collector;
                        Wrapper.collector = w;
                     }
                     a = b;
                     ay = by;
                     az = bz;
                     w = wNext;
                  }
                  if(wFirst == null)
                  {
                     face.processNext = null;
                     continue;
                  }
               }
               if(Boolean(faceCulling & 0x20))
               {
                  a = wLast.vertex;
                  ay = a.cameraY;
                  az = a.cameraZ;
                  w = wFirst;
                  wFirst = null;
                  wLast = null;
                  while(w != null)
                  {
                     wNext = w.next;
                     b = w.vertex;
                     by = b.cameraY;
                     bz = b.cameraZ;
                     if(bz > by && az <= ay || bz <= by && az > ay)
                     {
                        t = (az - ay) / (az - ay + by - bz);
                        v = b.create();
                        this.lastVertex.next = v;
                        this.lastVertex = v;
                        v.cameraX = a.cameraX + (b.cameraX - a.cameraX) * t;
                        v.cameraY = ay + (by - ay) * t;
                        v.cameraZ = az + (bz - az) * t;
                        v.x = a.x + (b.x - a.x) * t;
                        v.y = a.y + (b.y - a.y) * t;
                        v.z = a.z + (b.z - a.z) * t;
                        v.u = a.u + (b.u - a.u) * t;
                        v.v = a.v + (b.v - a.v) * t;
                        if(interpolateNormals)
                        {
                           v.normalX = a.normalX + (b.normalX - a.normalX) * t;
                           v.normalY = a.normalY + (b.normalY - a.normalY) * t;
                           v.normalZ = a.normalZ + (b.normalZ - a.normalZ) * t;
                        }
                        wNew = w.create();
                        wNew.vertex = v;
                        if(wFirst != null)
                        {
                           wLast.next = wNew;
                        }
                        else
                        {
                           wFirst = wNew;
                        }
                        wLast = wNew;
                     }
                     if(bz > by)
                     {
                        if(wFirst != null)
                        {
                           wLast.next = w;
                        }
                        else
                        {
                           wFirst = w;
                        }
                        wLast = w;
                        w.next = null;
                     }
                     else
                     {
                        w.vertex = null;
                        w.next = Wrapper.collector;
                        Wrapper.collector = w;
                     }
                     a = b;
                     ay = by;
                     az = bz;
                     w = wNext;
                  }
                  if(wFirst == null)
                  {
                     face.processNext = null;
                     continue;
                  }
               }
               face.processNext = null;
               newFace = face.create();
               newFace.material = face.material;
               this.lastFace.next = newFace;
               this.lastFace = newFace;
               newFace.wrapper = wFirst;
               face = newFace;
            }
            if(first != null)
            {
               last.processNext = face;
            }
            else
            {
               first = face;
            }
            last = face;
         }
         if(last != null)
         {
            last.processNext = null;
         }
         return first;
      }
   }
}

