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
      
      public static function load(completeListener:Function, progressListener:Function = null, afterCompleteListener:Function = null, bulkLoader:BulkLoader = null) : void
      {
         InitialDataLoader.completeListener = completeListener;
         InitialDataLoader.progressListener = progressListener;
         InitialDataLoader.afterCompleteListener = afterCompleteListener;
         loader = bulkLoader;
         if(bulkLoader == null)
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
         var context:LoaderContext = new LoaderContext();
         var i:int = 0;
         while(i < bmpURLs.length)
         {
            loader.add(bmpURLs[i],{
               "id":i,
               "context":context
            });
            i++;
         }
         loader.start();
      }
      
      private static function onLoadingProgress(bulkProgressEvent:BulkProgressEvent) : void
      {
         progressListener(bulkProgressEvent.ratioLoaded);
      }
      
      private static function onAllItemsLoaded(bulkProgressEvent:BulkProgressEvent) : void
      {
         var bitmapData:BitmapData = null;
         loader.removeEventListener(BulkLoader.PROGRESS,onLoadingProgress);
         loader.removeEventListener(BulkLoader.COMPLETE,onAllItemsLoaded);
         var i:int = 0;
         while(i < bmpURLs.length)
         {
            bitmapData = loader.getBitmapData(i);
            Assets.saveData(bmpURLs[i],bitmapData,BitmapData);
            if(bmpURLs[i].indexOf("skybox/") < 0)
            {
               textures[bitmapData] = true;
            }
            i++;
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

