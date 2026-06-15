package tutorial.commons
{
   import br.com.stimuli.loading.BulkLoader;
   import br.com.stimuli.loading.BulkProgressEvent;
   import flash.display.BitmapData;
   import flash.system.LoaderContext;
   import flash.utils.Dictionary;
   
   public class InitialDataLoader
   {
      
      private static var completeListener:Function;
      
      private static var progressListener:Function;
      
      private static var afterCompleteListener:Function;
      
      private static var loader:BulkLoader;
      
      private static var bmpURLs:Vector.<String> = new Vector.<String>();
      
      public static var textures:Dictionary = new Dictionary();
      
      public function InitialDataLoader()
      {
         super();
      }
      
      public static function load(param1:Function, param2:Function = null, param3:Function = null, param4:BulkLoader = null) : void
      {
         InitialDataLoader.completeListener = param1;
         InitialDataLoader.progressListener = param2;
         InitialDataLoader.afterCompleteListener = param3;
         loader = param4;
         if(param4 == null)
         {
            loader = new BulkLoader();
         }
         loader.addEventListener(BulkLoader.PROGRESS,onLoadingProgress);
         loader.addEventListener(BulkLoader.COMPLETE,onAllItemsLoaded);
         bmpURLs.push("resources/map/library2/hangar/hang_out.jpg");
         bmpURLs.push("resources/map/library2/hangar/hangar_b.jpg");
         bmpURLs.push("resources/map/library2/hangar/hangar1.jpg");
         bmpURLs.push("resources/map/library2/hangar/hangar_w.png");
         bmpURLs.push("resources/bitmaps/skybox/01.jpg");
         bmpURLs.push("resources/bitmaps/skybox/02.jpg");
         bmpURLs.push("resources/bitmaps/skybox/03.jpg");
         bmpURLs.push("resources/bitmaps/skybox/04.jpg");
         bmpURLs.push("resources/bitmaps/skybox/05.jpg");
         bmpURLs.push("resources/bitmaps/skybox/06.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_st_g.jpg");
         bmpURLs.push("resources/map/library2/builds/low/vilhou4.jpg");
         bmpURLs.push("resources/map/library2/builds/low/shit_1.jpg");
         bmpURLs.push("resources/map/library2/builds/low/nubu_6.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_st.jpg");
         bmpURLs.push("resources/map/library2/builds/low/shit_0.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_cr_g.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_e1_g.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_e3.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_e3_g.jpg");
         bmpURLs.push("resources/map/library2/builds/low/vilhou1.jpg");
         bmpURLs.push("resources/map/library2/builds/low/nubu_9.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_cr.jpg");
         bmpURLs.push("resources/map/library2/builds/low/vilhou1_2.jpg");
         bmpURLs.push("resources/map/library2/builds/low/nubu_10.jpg");
         bmpURLs.push("resources/map/library2/builds/low/nubu_5.jpg");
         bmpURLs.push("resources/map/library2/builds/low/vilhou4_2.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_e2.jpg");
         bmpURLs.push("resources/map/library2/builds/low/fab_tow.jpg");
         bmpURLs.push("resources/map/library2/builds/low/nubu_14.jpg");
         bmpURLs.push("resources/map/library2/builds/low/shit_2.jpg");
         bmpURLs.push("resources/map/library2/builds/low/wall_e2_g.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/wood1.png");
         bmpURLs.push("resources/map/library2/landscape/low/bush1.png");
         bmpURLs.push("resources/map/library2/landscape/low/bush2.png");
         bmpURLs.push("resources/map/library2/landscape/low/grass3_3_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/cliff_co.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pg_trans_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/cliff_c2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/gravel.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/slope_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dd_tr_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_tr_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_incor_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_tr_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/cliff_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass3_1_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pc_corner_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/slope_2b.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/cliff_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pg_trans_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_incor_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_road_det_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pave_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dd_incor_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dark_gravel.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pc_trans_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass3_1_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dd_tr_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_tr_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/cliff_r2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_cor_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pg_corner_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_cor_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pave_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/cliff_ri.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_cor_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dd_incor_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pg_trans_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass3_3_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_road_end.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pg_incor_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass2_2_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass2_2_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass2_1_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pg_corner_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_road_end_zebra.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_road.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dd_tr_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pave_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/slope_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass2_1_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_tr_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dg_cor_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass2_2_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass3_2_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_2.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_road_det_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/cliff_0.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass2_2_5.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pave_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/pc_trans_1.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dd_cor_4.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/dd_cor_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_road_det_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/grass3_3_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/concrete_3.jpg");
         bmpURLs.push("resources/map/library2/landscape/low/bridge_1.jpg");
         var _loc5_:LoaderContext = new LoaderContext();
         var _loc6_:int = 0;
         while(_loc6_ < bmpURLs.length)
         {
            loader.add(bmpURLs[_loc6_],{
               "id":_loc6_,
               "context":_loc5_
            });
            _loc6_++;
         }
         loader.start();
      }
      
      private static function onLoadingProgress(param1:BulkProgressEvent) : void
      {
         progressListener(param1.ratioLoaded);
      }
      
      private static function onAllItemsLoaded(param1:BulkProgressEvent) : void
      {
         var _loc3_:BitmapData = null;
         loader.removeEventListener(BulkLoader.PROGRESS,onLoadingProgress);
         loader.removeEventListener(BulkLoader.COMPLETE,onAllItemsLoaded);
         var _loc2_:int = 0;
         while(_loc2_ < bmpURLs.length)
         {
            _loc3_ = loader.getBitmapData(_loc2_);
            Assets.saveData(bmpURLs[_loc2_],_loc3_,BitmapData);
            if(bmpURLs[_loc2_].indexOf("skybox/") < 0)
            {
               textures[_loc3_] = true;
            }
            _loc2_++;
         }
         Assets.initialDataIsSaved = true;
         completeListener();
      }
      
      public static function onAfterComplete() : void
      {
         afterCompleteListener();
      }
   }
}

