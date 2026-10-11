package alternativa.physics.collision
{
   import alternativa.physics.collision.types.AABB;
   
   public class CollisionKdTree
   {
      
      private static const nodeBoundBoxThreshold:AABB = new AABB();
      
      private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
      
      private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
      
      private static const nodeBounds:Vector.<Number> = new Vector.<Number>(6);
      
      private static const primitiveBounds:Vector.<Number> = new Vector.<Number>(6);
      
      public var threshold:Number = 0.1;
      
      public var cihi:int = 1;
      
      public var rootNode:CollisionKdNode;
      
      public var primitives:Vector.<CollisionShape>;
      
      public var numPrimitives:int;
      
      public var boundBoxes:Vector.<AABB> = new Vector.<AABB>();
      
      private var splitAxis:int;
      
      private var splitCoord:Number;
      
      private var bestCost:Number;
      
      public function CollisionKdTree()
      {
         super();
      }
      
      public function createTree(shapes:Vector.<CollisionShape>, bounds:AABB = null) : void
      {
         var shape:CollisionShape = null;
         var primitiveBoundBox:AABB = null;
         this.primitives = shapes.concat();
         this.numPrimitives = this.primitives.length;
         this.rootNode = new CollisionKdNode();
         this.rootNode.indices = new Vector.<int>();
         var rootBoundBox:AABB = this.rootNode.boundBox = bounds != null ? bounds : new AABB();
         var i:int = 0;
         while(i < this.numPrimitives)
         {
            shape = this.primitives[i];
            primitiveBoundBox = this.boundBoxes[i] = shape.calculateAABB();
            rootBoundBox.addBoundBox(primitiveBoundBox);
            this.rootNode.indices[i] = i;
            i++;
         }
         this.boundBoxes.length = this.numPrimitives;
         this.splitNode(this.rootNode);
         splitCoordsX.length = splitCoordsY.length = splitCoordsZ.length = 0;
      }
      
      private function splitNode(node:CollisionKdNode) : void
      {
         var nodeBoundBox:AABB = null;
         var i:int = 0;
         var j:int = 0;
         var bound:AABB = null;
         var min:Number = NaN;
         var max:Number = NaN;
         var indices:Vector.<int> = node.indices;
         var numIndices:int = int(indices.length);
         if(numIndices <= this.cihi)
         {
            return;
         }
         nodeBoundBox = node.boundBox;
         nodeBoundBoxThreshold.minX = nodeBoundBox.minX + this.threshold;
         nodeBoundBoxThreshold.minY = nodeBoundBox.minY + this.threshold;
         nodeBoundBoxThreshold.minZ = nodeBoundBox.minZ + this.threshold;
         nodeBoundBoxThreshold.maxX = nodeBoundBox.maxX - this.threshold;
         nodeBoundBoxThreshold.maxY = nodeBoundBox.maxY - this.threshold;
         nodeBoundBoxThreshold.maxZ = nodeBoundBox.maxZ - this.threshold;
         var doubleThreshold:Number = this.threshold * 2;
         var numSplitCoordsX:int = 0;
         var numSplitCoordsY:int = 0;
         var numSplitCoordsZ:int = 0;
         i = 0;
         while(i < numIndices)
         {
            bound = this.boundBoxes[indices[i]];
            if(bound.maxX - bound.minX <= doubleThreshold)
            {
               if(bound.minX <= nodeBoundBoxThreshold.minX)
               {
                  splitCoordsX[numSplitCoordsX++] = nodeBoundBox.minX;
               }
               else if(bound.maxX >= nodeBoundBoxThreshold.maxX)
               {
                  splitCoordsX[numSplitCoordsX++] = nodeBoundBox.maxX;
               }
               else
               {
                  splitCoordsX[numSplitCoordsX++] = (bound.minX + bound.maxX) * 0.5;
               }
            }
            else
            {
               if(bound.minX > nodeBoundBoxThreshold.minX)
               {
                  splitCoordsX[numSplitCoordsX++] = bound.minX;
               }
               if(bound.maxX < nodeBoundBoxThreshold.maxX)
               {
                  splitCoordsX[numSplitCoordsX++] = bound.maxX;
               }
            }
            if(bound.maxY - bound.minY <= doubleThreshold)
            {
               if(bound.minY <= nodeBoundBoxThreshold.minY)
               {
                  splitCoordsY[numSplitCoordsY++] = nodeBoundBox.minY;
               }
               else if(bound.maxY >= nodeBoundBoxThreshold.maxY)
               {
                  splitCoordsY[numSplitCoordsY++] = nodeBoundBox.maxY;
               }
               else
               {
                  splitCoordsY[numSplitCoordsY++] = (bound.minY + bound.maxY) * 0.5;
               }
            }
            else
            {
               if(bound.minY > nodeBoundBoxThreshold.minY)
               {
                  splitCoordsY[numSplitCoordsY++] = bound.minY;
               }
               if(bound.maxY < nodeBoundBoxThreshold.maxY)
               {
                  splitCoordsY[numSplitCoordsY++] = bound.maxY;
               }
            }
            if(bound.maxZ - bound.minZ <= doubleThreshold)
            {
               if(bound.minZ <= nodeBoundBoxThreshold.minZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = nodeBoundBox.minZ;
               }
               else if(bound.maxZ >= nodeBoundBoxThreshold.maxZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = nodeBoundBox.maxZ;
               }
               else
               {
                  splitCoordsZ[numSplitCoordsZ++] = (bound.minZ + bound.maxZ) * 0.5;
               }
            }
            else
            {
               if(bound.minZ > nodeBoundBoxThreshold.minZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = bound.minZ;
               }
               if(bound.maxZ < nodeBoundBoxThreshold.maxZ)
               {
                  splitCoordsZ[numSplitCoordsZ++] = bound.maxZ;
               }
            }
            i++;
         }
         this.splitAxis = -1;
         this.bestCost = 1e+308;
         nodeBounds[0] = nodeBoundBox.minX;
         nodeBounds[1] = nodeBoundBox.minY;
         nodeBounds[2] = nodeBoundBox.minZ;
         nodeBounds[3] = nodeBoundBox.maxX;
         nodeBounds[4] = nodeBoundBox.maxY;
         nodeBounds[5] = nodeBoundBox.maxZ;
         this.checkNodeAxis(node,0,numSplitCoordsX,splitCoordsX,nodeBounds);
         this.checkNodeAxis(node,1,numSplitCoordsY,splitCoordsY,nodeBounds);
         this.checkNodeAxis(node,2,numSplitCoordsZ,splitCoordsZ,nodeBounds);
         if(this.splitAxis < 0)
         {
            return;
         }
         var axisX:Boolean = this.splitAxis == 0;
         var axisY:Boolean = this.splitAxis == 1;
         node.axis = this.splitAxis;
         node.coord = this.splitCoord;
         node.negative = new CollisionKdNode();
         node.negative.parent = node;
         node.negative.boundBox = nodeBoundBox.clone();
         node.positive = new CollisionKdNode();
         node.positive.parent = node;
         node.positive.boundBox = nodeBoundBox.clone();
         if(axisX)
         {
            node.negative.boundBox.maxX = node.positive.boundBox.minX = this.splitCoord;
         }
         else if(axisY)
         {
            node.negative.boundBox.maxY = node.positive.boundBox.minY = this.splitCoord;
         }
         else
         {
            node.negative.boundBox.maxZ = node.positive.boundBox.minZ = this.splitCoord;
         }
         var minCoord:Number = this.splitCoord - this.threshold;
         var maxCoord:Number = this.splitCoord + this.threshold;
         i = 0;
         while(i < numIndices)
         {
            bound = this.boundBoxes[indices[i]];
            min = axisX ? bound.minX : (axisY ? bound.minY : bound.minZ);
            max = axisX ? bound.maxX : (axisY ? bound.maxY : bound.maxZ);
            if(max <= maxCoord)
            {
               if(min < minCoord)
               {
                  if(node.negative.indices == null)
                  {
                     node.negative.indices = new Vector.<int>();
                  }
                  node.negative.indices.push(indices[i]);
                  indices[i] = -1;
               }
               else
               {
                  if(node.splitIndices == null)
                  {
                     node.splitIndices = new Vector.<int>();
                  }
                  node.splitIndices.push(indices[i]);
                  indices[i] = -1;
               }
            }
            else if(min >= minCoord)
            {
               if(node.positive.indices == null)
               {
                  node.positive.indices = new Vector.<int>();
               }
               node.positive.indices.push(indices[i]);
               indices[i] = -1;
            }
            i++;
         }
         i = 0;
         j = 0;
         while(i < numIndices)
         {
            if(indices[i] >= 0)
            {
               indices[j++] = indices[i];
            }
            i++;
         }
         if(j > 0)
         {
            indices.length = j;
         }
         else
         {
            node.indices = null;
         }
         if(node.splitIndices != null)
         {
            node.splitTree = new CollisionKdTree2D(this,node);
            node.splitTree.createTree();
         }
         if(node.negative.indices != null)
         {
            this.splitNode(node.negative);
         }
         if(node.positive.indices != null)
         {
            this.splitNode(node.positive);
         }
      }
      
      private function checkNodeAxis(node:CollisionKdNode, axis:int, numSplitCoords:int, splitCoords:Vector.<Number>, bounds:Vector.<Number>) : void
      {
         var coord:Number = NaN;
         var minCoord:Number = NaN;
         var maxCoord:Number = NaN;
         var areaNegative:Number = NaN;
         var areaPositive:Number = NaN;
         var numNegative:int = 0;
         var numPositive:int = 0;
         var conflict:Boolean = false;
         var numIndices:int = 0;
         var j:int = 0;
         var cost:Number = NaN;
         var bound:AABB = null;
         var axis1:int = (axis + 1) % 3;
         var axis2:int = (axis + 2) % 3;
         var area:Number = (bounds[axis1 + 3] - bounds[axis1]) * (bounds[axis2 + 3] - bounds[axis2]);
         var i:int = 0;
         while(i < numSplitCoords)
         {
            coord = splitCoords[i];
            if(!isNaN(coord))
            {
               minCoord = coord - this.threshold;
               maxCoord = coord + this.threshold;
               areaNegative = area * (coord - bounds[axis]);
               areaPositive = area * (bounds[int(axis + 3)] - coord);
               numNegative = 0;
               numPositive = 0;
               conflict = false;
               numIndices = int(node.indices.length);
               j = 0;
               while(j < numIndices)
               {
                  bound = this.boundBoxes[node.indices[j]];
                  primitiveBounds[0] = bound.minX;
                  primitiveBounds[1] = bound.minY;
                  primitiveBounds[2] = bound.minZ;
                  primitiveBounds[3] = bound.maxX;
                  primitiveBounds[4] = bound.maxY;
                  primitiveBounds[5] = bound.maxZ;
                  if(primitiveBounds[axis + 3] <= maxCoord)
                  {
                     if(primitiveBounds[axis] < minCoord)
                     {
                        numNegative++;
                     }
                  }
                  else
                  {
                     if(primitiveBounds[axis] < minCoord)
                     {
                        conflict = true;
                        break;
                     }
                     numPositive++;
                  }
                  j++;
               }
               cost = areaNegative * numNegative + areaPositive * numPositive;
               if(!conflict && cost < this.bestCost && numNegative > 0 && numPositive > 0)
               {
                  this.splitAxis = axis;
                  this.bestCost = cost;
                  this.splitCoord = coord;
               }
               j = i + 1;
               while(j < numSplitCoords)
               {
                  if(splitCoords[j] >= coord - this.threshold && splitCoords[j] <= coord + this.threshold)
                  {
                     splitCoords[j] = NaN;
                  }
                  j++;
               }
            }
            i++;
         }
      }
      
      public function traceTree() : void
      {
         this.traceNode("",this.rootNode);
      }
      
      private function traceNode(prefix:String, node:CollisionKdNode) : void
      {
         if(node == null)
         {
            return;
         }
         this.traceNode(prefix + "-",node.negative);
         this.traceNode(prefix + "+",node.positive);
      }
   }
}

