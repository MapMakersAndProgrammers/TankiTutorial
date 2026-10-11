package alternativa.utils
{
   import flash.utils.Dictionary;
   
   public function clearDictionary(dictionary:Dictionary) : void
   {
      var key:* = undefined;
      for(key in dictionary)
      {
         delete dictionary[key];
      }
   }
}

