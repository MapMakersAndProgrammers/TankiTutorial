package embed
{
   import §&@§.§@!4§;
   import §'n§.§,f§;
   import §4§.§-k§;
   import §]!5§.§1!#§;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.utils.ByteArray;
   import movieclips.ControlsClip;
   import movieclips.FinishClip;
   import movieclips.TurnedUpClip;
   import tutorial.commons.Assets;
   import tutorial.commons.UnpackingProgressUpdating;
   
   public class Embed
   {
      
      private static var listener:Function;
      
      private static var currentURL:String;
      
      private static var loader:Loader;
      
      private static var currentBMP:BitmapData;
      
      private static var currentEffect:Object;
      
      private static const ammo_3dz:Class = Embed_ammo_3dz;
      
      private static const barr_1_3dz:Class = Embed_barr_1_3dz;
      
      private static const barr_2_3dz:Class = Embed_barr_2_3dz;
      
      private static const computer_3dz:Class = Embed_computer_3dz;
      
      private static const door_3dz:Class = Embed_door_3dz;
      
      private static const gener_3dz:Class = Embed_gener_3dz;
      
      private static const hang_in_3dz:Class = Embed_hang_in_3dz;
      
      private static const hang_out_3dz:Class = Embed_hang_out_3dz;
      
      private static const noDo_3dz:Class = Embed_noDo_3dz;
      
      private static const toolDesk_3dz:Class = Embed_toolDesk_3dz;
      
      private static const topPeril_3dz:Class = Embed_topPeril_3dz;
      
      private static const wire_1_3dz:Class = Embed_wire_1_3dz;
      
      private static const bilboard_3dz:Class = Embed_bilboard_3dz;
      
      private static const fab_tow_3dz:Class = Embed_fab_tow_3dz;
      
      private static const fab_tow2_3dz:Class = Embed_fab_tow2_3dz;
      
      private static const nubu_1_3dz:Class = Embed_nubu_1_3dz;
      
      private static const nubu_10_3dz:Class = Embed_nubu_10_3dz;
      
      private static const nubu_11_3dz:Class = Embed_nubu_11_3dz;
      
      private static const nubu_12_3dz:Class = Embed_nubu_12_3dz;
      
      private static const nubu_13_3dz:Class = Embed_nubu_13_3dz;
      
      private static const nubu_14_3dz:Class = Embed_nubu_14_3dz;
      
      private static const nubu_2_3dz:Class = Embed_nubu_2_3dz;
      
      private static const nubu_3_3dz:Class = Embed_nubu_3_3dz;
      
      private static const nubu_4_3dz:Class = Embed_nubu_4_3dz;
      
      private static const nubu_5_3dz:Class = Embed_nubu_5_3dz;
      
      private static const nubu_6_3dz:Class = Embed_nubu_6_3dz;
      
      private static const nubu_7_3dz:Class = Embed_nubu_7_3dz;
      
      private static const nubu_8_3dz:Class = Embed_nubu_8_3dz;
      
      private static const nubu_9_3dz:Class = Embed_nubu_9_3dz;
      
      private static const vilhou_1_3dz:Class = Embed_vilhou_1_3dz;
      
      private static const vilhou_2_3dz:Class = Embed_vilhou_2_3dz;
      
      private static const vilhou_3_3dz:Class = Embed_vilhou_3_3dz;
      
      private static const vilhou_4_3dz:Class = Embed_vilhou_4_3dz;
      
      private static const wall_3w_3dz:Class = Embed_wall_3w_3dz;
      
      private static const wall_cr_3dz:Class = Embed_wall_cr_3dz;
      
      private static const wall_e1_3dz:Class = Embed_wall_e1_3dz;
      
      private static const wall_e2_3dz:Class = Embed_wall_e2_3dz;
      
      private static const wall_e3_3dz:Class = Embed_wall_e3_3dz;
      
      private static const wall_st_3dz:Class = Embed_wall_st_3dz;
      
      private static const br_01_3dz:Class = Embed_br_01_3dz;
      
      private static const bridge_1_1_3dz:Class = Embed_bridge_1_1_3dz;
      
      private static const bridge_1_3dz:Class = Embed_bridge_1_3dz;
      
      private static const bridge_2_3dz:Class = Embed_bridge_2_3dz;
      
      private static const bridge_3_3dz:Class = Embed_bridge_3_3dz;
      
      private static const bridge_4_3dz:Class = Embed_bridge_4_3dz;
      
      private static const bridge_5_3dz:Class = Embed_bridge_5_3dz;
      
      private static const bridge_8_3dz:Class = Embed_bridge_8_3dz;
      
      private static const cliff_0_3ds:Class = Embed_cliff_0_3ds;
      
      private static const cliff_1_3ds:Class = Embed_cliff_1_3ds;
      
      private static const cliff_2_3ds:Class = Embed_cliff_2_3ds;
      
      private static const cliff_4_3ds:Class = Embed_cliff_4_3ds;
      
      private static const cliff_c2_3ds:Class = Embed_cliff_c2_3ds;
      
      private static const cliff_cor_3ds:Class = Embed_cliff_cor_3ds;
      
      private static const cliff_cor2_3ds:Class = Embed_cliff_cor2_3ds;
      
      private static const cliff_r2_3ds:Class = Embed_cliff_r2_3ds;
      
      private static const cliff_ri_3ds:Class = Embed_cliff_ri_3ds;
      
      private static const fliptile_3dz:Class = Embed_fliptile_3dz;
      
      private static const rise_2_3dz:Class = Embed_rise_2_3dz;
      
      private static const rise_3_3dz:Class = Embed_rise_3_3dz;
      
      private static const rise_4_3dz:Class = Embed_rise_4_3dz;
      
      private static const rise_5_3dz:Class = Embed_rise_5_3dz;
      
      private static const slope_1_3dz:Class = Embed_slope_1_3dz;
      
      private static const slope_2_3dz:Class = Embed_slope_2_3dz;
      
      private static const smbr_1_3dz:Class = Embed_smbr_1_3dz;
      
      private static const smbr_2_3dz:Class = Embed_smbr_2_3dz;
      
      private static const smbr_3_3dz:Class = Embed_smbr_3_3dz;
      
      private static const smbr_4_3dz:Class = Embed_smbr_4_3dz;
      
      private static const smbr_5_3dz:Class = Embed_smbr_5_3dz;
      
      private static const smbr_6_3dz:Class = Embed_smbr_6_3dz;
      
      private static const tile_01_3dz:Class = Embed_tile_01_3dz;
      
      private static const tile2_1_3dz:Class = Embed_tile2_1_3dz;
      
      private static const tile2_2_3dz:Class = Embed_tile2_2_3dz;
      
      private static const tile3_1_3dz:Class = Embed_tile3_1_3dz;
      
      private static const tile3_2_3dz:Class = Embed_tile3_2_3dz;
      
      private static const tile3_3_3dz:Class = Embed_tile3_3_3dz;
      
      private static const box_med_3ds:Class = Embed_box_med_3ds;
      
      private static const parachute_inner_3ds:Class = Embed_parachute_inner_3ds;
      
      private static const parachute_3ds:Class = Embed_parachute_3ds;
      
      private static const box_med_jpg:Class = Embed_box_med_jpg;
      
      private static const box_crystal_jpg:Class = Embed_box_crystal_jpg;
      
      private static const para_jpg:Class = Embed_para_jpg;
      
      private static const repairKitClass:Class = Embed_repairKitClass;
      
      private static const viking_3dz:Class = Embed_viking_3dz;
      
      private static const viking_bin:Class = Embed_viking_bin;
      
      private static const viking_jpg:Class = Embed_viking_jpg;
      
      private static const hornet_3dz:Class = Embed_hornet_3dz;
      
      private static const hornet_bin:Class = Embed_hornet_bin;
      
      private static const hornet_jpg:Class = Embed_hornet_jpg;
      
      private static const mammoth_3dz:Class = Embed_mammoth_3dz;
      
      private static const mammoth_bin:Class = Embed_mammoth_bin;
      
      private static const mammoth_jpg:Class = Embed_mammoth_jpg;
      
      private static const thunder_3dz:Class = Embed_thunder_3dz;
      
      private static const thunder_bin:Class = Embed_thunder_bin;
      
      private static const thunder_jpg:Class = Embed_thunder_jpg;
      
      private static const firebird_3dz:Class = Embed_firebird_3dz;
      
      private static const firebird_bin:Class = Embed_firebird_bin;
      
      private static const firebird_jpg:Class = Embed_firebird_jpg;
      
      private static const twins_3dz:Class = Embed_twins_3dz;
      
      private static const twins_bin:Class = Embed_twins_bin;
      
      private static const twins_jpg:Class = Embed_twins_jpg;
      
      private static const shot_m3_bin:Class = Embed_shot_m3_bin;
      
      private static const shot_bin:Class = Embed_shot_bin;
      
      private static const arrow_gif:Class = Embed_arrow_gif;
      
      private static const blue_gif:Class = Embed_blue_gif;
      
      private static const cords_gif:Class = Embed_cords_gif;
      
      private static const target_pointer_gif:Class = Embed_target_pointer_gif;
      
      private static const shadow_gif:Class = Embed_shadow_gif;
      
      private static const black_jpg:Class = Embed_black_jpg;
      
      private static const dead_jpg:Class = Embed_dead_jpg;
      
      private static const help_png:Class = Embed_help_png;
      
      private static const help_de_png:Class = Embed_help_de_png;
      
      private static const player_png:Class = Embed_player_png;
      
      private static const red_png:Class = Embed_red_png;
      
      private static const dust:Class = Embed_dust;
      
      private static const marking:Class = Embed_marking;
      
      private static const help_mouse:Class = Embed_help_mouse;
      
      private static const explosion_bin:Class = Embed_explosion_bin;
      
      private static const FBZm3_bin:Class = Embed_FBZm3_bin;
      
      private static const fireball_bin:Class = Embed_fireball_bin;
      
      private static const shock_wave_bin:Class = Embed_shock_wave_bin;
      
      private static const shot2_bin:Class = Embed_shot2_bin;
      
      private static const smoke_bin:Class = Embed_smoke_bin;
      
      private static const TH_M3_bin:Class = Embed_TH_M3_bin;
      
      private static const twins_explosion_bin:Class = Embed_twins_explosion_bin;
      
      private static const map_bin:Class = Embed_map_bin;
      
      private static const builds_xml:Class = Embed_builds_xml;
      
      private static const hangar_xml:Class = Embed_hangar_xml;
      
      private static const landscape_xml:Class = Embed_landscape_xml;
      
      private static const fill_png:Class = Embed_fill_png;
      
      private static const fill_over_png:Class = Embed_fill_over_png;
      
      private static const fill_pressed_png:Class = Embed_fill_pressed_png;
      
      private static const left_png:Class = Embed_left_png;
      
      private static const left_over_png:Class = Embed_left_over_png;
      
      private static const left_pressed_png:Class = Embed_left_pressed_png;
      
      public static const LEFT:BitmapData = new left_png().bitmapData;
      
      public static const FILL:BitmapData = new fill_png().bitmapData;
      
      public static const LEFT_OVER:BitmapData = new left_over_png().bitmapData;
      
      public static const FILL_OVER:BitmapData = new fill_over_png().bitmapData;
      
      public static const LEFT_PRESSED:BitmapData = new left_pressed_png().bitmapData;
      
      public static const FILL_PRESSED:BitmapData = new fill_pressed_png().bitmapData;
      
      private static var binMap:Object = {};
      
      private static var swfMap:Object = {};
      
      private static var effectMap:Object = {};
      
      private static var diffuse:ByteArray = new ByteArray();
      
      private static var alpha:ByteArray = new ByteArray();
      
      public function Embed()
      {
         super();
      }
      
      public static function init(param1:Function) : void
      {
         var _loc2_:String = null;
         listener = param1;
         _loc2_ = "resources/map/library2/hangar/";
         Assets.saveData(_loc2_ + "ammo.3dz",parse3DZ(new ammo_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "barr_1.3dz",parse3DZ(new barr_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "barr_2.3dz",parse3DZ(new barr_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "computer.3dz",parse3DZ(new computer_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "door.3dz",parse3DZ(new door_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "gener.3dz",parse3DZ(new gener_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "hang_in.3dz",parse3DZ(new hang_in_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "hang_out.3dz",parse3DZ(new hang_out_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "noDo.3dz",parse3DZ(new noDo_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "toolDesk.3dz",parse3DZ(new toolDesk_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "topPeril.3dz",parse3DZ(new topPeril_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "wire_1.3dz",parse3DZ(new wire_1_3dz()),Parser3DS);
         _loc2_ = "resources/map/library2/builds/";
         Assets.saveData(_loc2_ + "bilboard.3dz",parse3DZ(new bilboard_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "fab_tow.3dz",parse3DZ(new fab_tow_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "fab_tow2.3dz",parse3DZ(new fab_tow2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_1.3dz",parse3DZ(new nubu_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_10.3dz",parse3DZ(new nubu_10_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_11.3dz",parse3DZ(new nubu_11_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_12.3dz",parse3DZ(new nubu_12_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_13.3dz",parse3DZ(new nubu_13_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_14.3dz",parse3DZ(new nubu_14_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_2.3dz",parse3DZ(new nubu_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_3.3dz",parse3DZ(new nubu_3_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_4.3dz",parse3DZ(new nubu_4_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_5.3dz",parse3DZ(new nubu_5_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_6.3dz",parse3DZ(new nubu_6_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_7.3dz",parse3DZ(new nubu_7_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_8.3dz",parse3DZ(new nubu_8_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "nubu_9.3dz",parse3DZ(new nubu_9_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "vilhou_1.3dz",parse3DZ(new vilhou_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "vilhou_2.3dz",parse3DZ(new vilhou_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "vilhou_3.3dz",parse3DZ(new vilhou_3_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "vilhou_4.3dz",parse3DZ(new vilhou_4_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "wall_3w.3dz",parse3DZ(new wall_3w_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "wall_cr.3dz",parse3DZ(new wall_cr_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "wall_e1.3dz",parse3DZ(new wall_e1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "wall_e2.3dz",parse3DZ(new wall_e2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "wall_e3.3dz",parse3DZ(new wall_e3_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "wall_st.3dz",parse3DZ(new wall_st_3dz()),Parser3DS);
         _loc2_ = "resources/map/library2/landscape/";
         Assets.saveData(_loc2_ + "br_01.3dz",parse3DZ(new br_01_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "bridge_1_1.3dz",parse3DZ(new bridge_1_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "bridge_1.3dz",parse3DZ(new bridge_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "bridge_2.3dz",parse3DZ(new bridge_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "bridge_3.3dz",parse3DZ(new bridge_3_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "bridge_4.3dz",parse3DZ(new bridge_4_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "bridge_5.3dz",parse3DZ(new bridge_5_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "bridge_8.3dz",parse3DZ(new bridge_8_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_0.3dz",parse3DS(new cliff_0_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_1.3dz",parse3DS(new cliff_1_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_2.3dz",parse3DS(new cliff_2_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_4.3dz",parse3DS(new cliff_4_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_c2.3dz",parse3DS(new cliff_c2_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_cor.3dz",parse3DS(new cliff_cor_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_cor2.3dz",parse3DS(new cliff_cor2_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_r2.3dz",parse3DS(new cliff_r2_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "cliff_ri.3dz",parse3DS(new cliff_ri_3ds()),Parser3DS);
         Assets.saveData(_loc2_ + "fliptile.3dz",parse3DZ(new fliptile_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "rise_2.3dz",parse3DZ(new rise_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "rise_3.3dz",parse3DZ(new rise_3_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "rise_4.3dz",parse3DZ(new rise_4_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "rise_5.3dz",parse3DZ(new rise_5_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "slope_1.3dz",parse3DZ(new slope_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "slope_2.3dz",parse3DZ(new slope_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "smbr_1.3dz",parse3DZ(new smbr_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "smbr_2.3dz",parse3DZ(new smbr_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "smbr_3.3dz",parse3DZ(new smbr_3_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "smbr_4.3dz",parse3DZ(new smbr_4_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "smbr_5.3dz",parse3DZ(new smbr_5_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "smbr_6.3dz",parse3DZ(new smbr_6_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "tile_01.3dz",parse3DZ(new tile_01_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "tile2_1.3dz",parse3DZ(new tile2_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "tile2_2.3dz",parse3DZ(new tile2_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "tile3_1.3dz",parse3DZ(new tile3_1_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "tile3_2.3dz",parse3DZ(new tile3_2_3dz()),Parser3DS);
         Assets.saveData(_loc2_ + "tile3_3.3dz",parse3DZ(new tile3_3_3dz()),Parser3DS);
         defferedSaveBin("smoky_shot",new shot_m3_bin());
         defferedSaveBin("plasma",new shot_bin());
         Assets.saveData("arrow",new arrow_gif().bitmapData,BitmapData);
         Assets.saveData("blue",new blue_gif().bitmapData,BitmapData);
         var _loc3_:BitmapData = new cords_gif().bitmapData;
         §,f§.§5V§(_loc3_);
         Assets.saveData("cords",_loc3_,BitmapData);
         Assets.saveData("target_pointer",new target_pointer_gif().bitmapData,BitmapData);
         Assets.saveData("shadow",new shadow_gif().bitmapData,BitmapData);
         Assets.saveData("black",new black_jpg().bitmapData,BitmapData);
         Assets.saveData("dead",new dead_jpg().bitmapData,BitmapData);
         Assets.saveData("help_png",new help_png().bitmapData,BitmapData);
         Assets.saveData("help_de_png",new help_de_png().bitmapData,BitmapData);
         Assets.saveData("green",new player_png().bitmapData,BitmapData);
         Assets.saveData("red",new red_png().bitmapData,BitmapData);
         Assets.saveData("dust",new dust().bitmapData,BitmapData);
         Assets.saveData("marking",new marking().bitmapData,BitmapData);
         Assets.saveData("help_mouse",new help_mouse().bitmapData,BitmapData);
         defferedSaveEffect("tank_explosion/explosion",new explosion_bin(),0,170,170);
         defferedSaveEffect("flame_muzzle",new FBZm3_bin(),0,256,51);
         defferedSaveEffect("flame",new fireball_bin(),51,64,64);
         defferedSaveEffect("tank_explosion/shockwave",new shock_wave_bin(),0,128,128);
         defferedSaveEffect("plasma",new shot2_bin(),10,128,128);
         defferedSaveEffect("tank_explosion/smoke",new smoke_bin(),0,64,64);
         defferedSaveEffect("smoky_explosion",new TH_M3_bin(),0,170,170);
         defferedSaveEffect("plasma_exp",new twins_explosion_bin(),12,256,256);
         Assets.saveData("med",new box_med_3ds(),ByteArray);
         Assets.saveData("crystal",new box_med_3ds(),ByteArray);
         Assets.saveData("parachute_inner",new parachute_inner_3ds(),ByteArray);
         Assets.saveData("parachute",new parachute_3ds(),ByteArray);
         var _loc4_:BitmapData = new box_med_jpg().bitmapData;
         §,f§.§5V§(_loc4_);
         Assets.saveData("med",_loc4_,BitmapData);
         var _loc5_:BitmapData = new box_crystal_jpg().bitmapData;
         §,f§.§5V§(_loc5_);
         Assets.saveData("crystal",_loc5_,BitmapData);
         var _loc6_:BitmapData = new para_jpg().bitmapData;
         §,f§.§5V§(_loc6_);
         Assets.saveData("parachute_inner",_loc6_,BitmapData);
         Assets.saveData("parachute",_loc6_,BitmapData);
         var _loc7_:BitmapData = new repairKitClass().bitmapData;
         §,f§.§5V§(_loc7_);
         Assets.saveData("repairKitBonusRegion",_loc7_,BitmapData);
         _loc2_ = "resources/hulls/";
         Assets.saveData(_loc2_ + "viking.3dz",new viking_3dz(),ByteArray);
         Assets.saveData(_loc2_ + "viking.jpg",new viking_jpg().bitmapData,BitmapData);
         defferedSaveBin(_loc2_ + "viking.bin",new viking_bin());
         Assets.saveData(_loc2_ + "hornet.3dz",new hornet_3dz(),ByteArray);
         Assets.saveData(_loc2_ + "hornet.jpg",new hornet_jpg().bitmapData,BitmapData);
         defferedSaveBin(_loc2_ + "hornet.bin",new hornet_bin());
         Assets.saveData(_loc2_ + "mammoth.3dz",new mammoth_3dz(),ByteArray);
         Assets.saveData(_loc2_ + "mammoth_low.jpg",new mammoth_jpg().bitmapData,BitmapData);
         defferedSaveBin(_loc2_ + "mammoth.bin",new mammoth_bin());
         _loc2_ = "resources/turrets/";
         Assets.saveData(_loc2_ + "thunder.3dz",new thunder_3dz(),ByteArray);
         Assets.saveData(_loc2_ + "thunder_low.jpg",new thunder_jpg().bitmapData,BitmapData);
         defferedSaveBin(_loc2_ + "thunder.bin",new thunder_bin());
         Assets.saveData(_loc2_ + "firebird.3dz",new firebird_3dz(),ByteArray);
         Assets.saveData(_loc2_ + "firebird_low.jpg",new firebird_jpg().bitmapData,BitmapData);
         defferedSaveBin(_loc2_ + "firebird.bin",new firebird_bin());
         Assets.saveData(_loc2_ + "twins.3dz",new twins_3dz(),ByteArray);
         Assets.saveData(_loc2_ + "twins_low.jpg",new twins_jpg().bitmapData,BitmapData);
         defferedSaveBin(_loc2_ + "twins.bin",new twins_bin());
         Assets.saveData("delete_help",new TurnedUpClip(),MovieClip);
         Assets.saveData("finish",new FinishClip(),MovieClip);
         Assets.saveData("help",new ControlsClip(),MovieClip);
         Assets.saveData("resources/map/map.bin",new map_bin(),ByteArray);
         Assets.saveData("resources/map/library2/builds/library.xml",XML(new builds_xml()),XML);
         Assets.saveData("resources/map/library2/hangar/library.xml",XML(new hangar_xml()),XML);
         Assets.saveData("resources/map/library2/landscape/library.xml",XML(new landscape_xml()),XML);
         uncompressBin();
      }
      
      private static function parse3DZ(param1:ByteArray) : Parser3DS
      {
         var _loc2_:Parser3DS = new Parser3DS();
         param1.uncompress();
         _loc2_.parse(param1);
         var _loc3_:Mesh = Mesh(_loc2_.objects[0]);
         _loc3_.weldVertices(0.001,0.0001);
         _loc3_.weldFaces(0.001,0.0001,0.01);
         _loc3_.calculateVerticesNormalsByAngle(§,f§.§!C§,§,f§.§5'§);
         _loc3_.calculateVerticesNormalsByAngle(§,f§.§!C§,§,f§.§5'§);
         return _loc2_;
      }
      
      private static function parse3DS(param1:ByteArray) : Parser3DS
      {
         var _loc2_:Parser3DS = new Parser3DS();
         _loc2_.parse(param1);
         var _loc3_:Mesh = Mesh(_loc2_.objects[0]);
         _loc3_.weldVertices(0.001,0.0001);
         _loc3_.weldFaces(0.001,0.0001,0.01);
         _loc3_.calculateVerticesNormalsByAngle(§,f§.§!C§,§,f§.§5'§);
         _loc3_.calculateVerticesNormalsByAngle(§,f§.§!C§,§,f§.§5'§);
         return _loc2_;
      }
      
      private static function defferedSaveBin(param1:String, param2:ByteArray) : void
      {
         binMap[param1] = param2;
      }
      
      private static function defferedSaveSwf(param1:String, param2:ByteArray) : void
      {
         swfMap[param1] = param2;
      }
      
      private static function defferedSaveEffect(param1:String, param2:ByteArray, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:Object = new Object();
         _loc6_["width"] = param4;
         _loc6_["height"] = param5;
         _loc6_["numFrames"] = param3;
         _loc6_["data"] = param2;
         effectMap[param1] = _loc6_;
      }
      
      private static function uncompressBin() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         UnpackingProgressUpdating.update();
         var _loc1_:ByteArray = null;
         var _loc5_:int = 0;
         var _loc6_:* = binMap;
         for(_loc2_ in _loc6_)
         {
            currentURL = _loc2_;
            _loc1_ = binMap[_loc2_];
            delete binMap[_loc2_];
         }
         if(_loc1_ != null)
         {
            _loc1_.uncompress();
            diffuse.length = 0;
            alpha.length = 0;
            _loc3_ = _loc1_.readUnsignedInt();
            _loc1_.readBytes(diffuse,0,_loc3_);
            _loc4_ = _loc1_.readUnsignedInt();
            _loc1_.readBytes(alpha,0,_loc4_);
            loader = §@!4§.§[K§(onOpaueLoaded,uncompressBin);
            loader.loadBytes(diffuse);
         }
         else
         {
            uncompressEffect();
            binMap = null;
         }
      }
      
      private static function uncompressEffect() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         UnpackingProgressUpdating.update();
         currentEffect = null;
         var _loc5_:int = 0;
         var _loc6_:* = effectMap;
         for(_loc1_ in _loc6_)
         {
            currentURL = _loc1_;
            currentEffect = effectMap[_loc1_];
            delete effectMap[_loc1_];
         }
         if(currentEffect != null)
         {
            _loc2_ = currentEffect["data"];
            _loc2_.uncompress();
            diffuse.length = 0;
            alpha.length = 0;
            _loc3_ = _loc2_.readUnsignedInt();
            _loc2_.readBytes(diffuse,0,_loc3_);
            _loc4_ = _loc2_.readUnsignedInt();
            _loc2_.readBytes(alpha,0,_loc4_);
            loader = §@!4§.§[K§(onOpaueLoadedEffect,uncompressEffect);
            loader.loadBytes(diffuse);
         }
         else
         {
            uncompressSwf();
            effectMap = null;
            currentBMP = null;
            diffuse = null;
            alpha = null;
         }
      }
      
      private static function onOpaueLoaded(param1:Event) : void
      {
         UnpackingProgressUpdating.update();
         var _loc2_:BitmapData = Bitmap(loader.content).bitmapData;
         currentBMP = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         currentBMP.copyPixels(_loc2_,_loc2_.rect,new Point());
         _loc2_.dispose();
         loader = §@!4§.§[K§(onAlphaLoaded,uncompressBin);
         loader.loadBytes(alpha);
      }
      
      private static function onAlphaLoaded(param1:Event) : void
      {
         UnpackingProgressUpdating.update();
         var _loc2_:BitmapData = Bitmap(loader.content).bitmapData;
         currentBMP.copyChannel(_loc2_,_loc2_.rect,new Point(),1,8);
         _loc2_.dispose();
         Assets.saveData(currentURL,currentBMP,BitmapData);
         uncompressBin();
      }
      
      private static function onOpaueLoadedEffect(param1:Event) : void
      {
         UnpackingProgressUpdating.update();
         var _loc2_:BitmapData = Bitmap(loader.content).bitmapData;
         currentBMP = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         currentBMP.copyPixels(_loc2_,_loc2_.rect,new Point());
         _loc2_.dispose();
         loader = §@!4§.§[K§(onAlphaLoadedEffect,uncompressEffect);
         loader.loadBytes(alpha);
      }
      
      private static function onAlphaLoadedEffect(param1:Event) : void
      {
         UnpackingProgressUpdating.update();
         var _loc2_:BitmapData = Bitmap(loader.content).bitmapData;
         currentBMP.copyChannel(_loc2_,_loc2_.rect,new Point(),1,8);
         _loc2_.dispose();
         Assets.saveData(currentURL,new §1!#§(new TextureMaterial(currentBMP),§-k§.§6!!§(currentBMP,currentEffect["width"],currentEffect["height"],currentEffect["numFrames"]),30),§1!#§);
         uncompressEffect();
      }
      
      private static function uncompressSwf() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:String = null;
         UnpackingProgressUpdating.update();
         var _loc3_:int = 0;
         var _loc4_:* = swfMap;
         for(_loc2_ in _loc4_)
         {
            currentURL = _loc2_;
            _loc1_ = swfMap[_loc2_];
            delete swfMap[_loc2_];
         }
         if(_loc1_ != null)
         {
            loader = §@!4§.§[K§(onSwfLoaded,uncompressSwf);
            loader.loadBytes(_loc1_);
         }
         else
         {
            listener();
            swfMap = null;
            loader = null;
            listener = null;
         }
      }
      
      private static function onSwfLoaded(param1:Event) : void
      {
         UnpackingProgressUpdating.update();
         Assets.saveData(currentURL,loader.content,MovieClip);
         uncompressSwf();
      }
   }
}

