package  
{
	/*TODO: 
		1) add a timer
		2) user-defined board size
	    3) click revealed cell and open all non-revealed suroundding
	
	*/
	
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	//import flash.filters.GradientBevelFilter;	// for UI beautify
	
	//[SWF(width="1800", height="600", frameRate="60", backgroundColor="#0")] //set backgraound color
	
	public class MineSweeper extends Sprite 
	{
		public var cells:Array;
		public var board:Sprite;
		public var boardWidth:int;
		public var boardHeight:int;
		public var buttonSize:uint;
		public var totalMine:int;
		public var remainingMine:int;
		public var remainingMineText:TextField;
		public var numOfRevealed:int;

		public var restartButton:SimpleButton = new SimpleButton();

		public var up:Sprite = new Sprite();
		
		public function MineSweeper()	//constructor
		{	
			totalMine = 30;
			remainingMine = totalMine;
			numOfRevealed = 0;
			boardWidth = 15;
			boardHeight = 15;
			buttonSize = 20;
			
			cells = new Array();
			
			remainingMineText = new TextField();
			remainingMineText.text = "Mines left: " + remainingMine.toString();
			remainingMineText.x = 310;
			remainingMineText.y = 100;
			addChild(remainingMineText);
			
			var note:TextField = new TextField();
			note.text = "shift+click to mark!";
			note.x = 10;
			note.y = 320;
			addChild(note);
			
			up.graphics.lineStyle(1, 0x000000);
			up.graphics.beginFill(0xBBCCDD);
			up.graphics.drawRect(310, 150, 70, 20);
			
			var restartLabel:TextField = new TextField();
			restartLabel.text = "Restart";
			restartLabel.x = 325;
			restartLabel.y = 150;
			up.addChild(restartLabel);
			
			restartButton.upState = up;
			restartButton.downState = up;
			restartButton.overState = up;
			restartButton.useHandCursor = true;
			restartButton.hitTestState = up;
			restartButton.addEventListener(MouseEvent.CLICK, restart);
			
			
			this.addChild(restartButton);
			
			
			board = new Sprite();	
			addChildAt(board, 0);
			
			generateBoard(0,0,boardWidth,boardHeight);	// startX, startY, totalRows, totalCols, buttonSize
			
			plantMine();
			placeNumbers();
			
			
		}	//end of constructor
		
		private function generateBoard(startX:uint,startY:uint,totalRows:int,totalCols:Number):void 
		{	
			var colCounter:uint;
			var rowCounter:uint;
			
			for(rowCounter = 0; rowCounter < totalRows; rowCounter++) 
			{				
				for(colCounter = 0; colCounter < totalCols; colCounter++) 
				{	
					var newCell:Cell = new Cell(startX + (colCounter*buttonSize),startY + (rowCounter*buttonSize), buttonSize);
					board.addChild(newCell);
					this.addChild(newCell);
					cells.push(newCell);
					
				}
			}
		}
		
		private function plantMine():void
		{
			var bombsCounter:uint = totalMine;
			
			while(bombsCounter > 0)
			{
				var randomNumber:Number = Math.round(Math.random()* ((boardHeight * boardWidth) - 1));
				
				if(!cells[randomNumber].mined)
				{
					cells[randomNumber].mined = true;
					bombsCounter--;
				}
				
			}
		}
		
		private function placeNumbers():void{
			
			for (var index:int in cells) 
			{
				getListOfMine(cells[index]);
				
				if(cells[index].numOfMine == 0)
				{
					cells[index].cellLabel.text = "";
				}
				else
				{
					cells[index].cellLabel.text = (cells[index].numOfMine).toString();
				}
			}
			
		}
		
		public function getListOfMine(cell:Cell):Array
		{
			var id:int = cells.indexOf(cell)
			var neighborList:Array = [];	//list of surrounding neighbors
			var neighbor:int = new int();	//number of surrounding neighbors
			var num:int = new int();	//number of surroudning mines
			
			if(id == 0)	//3 neighbors
			{
				neighbor = 3;
				num = cells[id+1].mined + cells[id + boardWidth].mined + cells[id+boardWidth+1].mined;
				neighborList.push(cells[id+1], cells[id + boardWidth], cells[id+boardWidth+1]);

			}
			else if(id == boardWidth -1)
			{
				neighbor = 3;
				num = cells[id-1].mined + cells[id+boardWidth-1].mined + cells[id+boardWidth].mined;
				neighborList.push(cells[id-1], cells[id+boardWidth-1], cells[id+boardWidth]);

			}
			else if(id == boardWidth*boardHeight - boardWidth)
			{
				neighbor = 3;
				num = cells[id-boardWidth].mined + cells[id-boardWidth+1].mined + cells[id+1].mined;
				neighborList.push(cells[id-boardWidth], cells[id-boardWidth+1], cells[id+1]);

			}
			else if(id ==  boardWidth*boardHeight - 1)
			{
				neighbor = 3;
				num = cells[id-boardWidth-1].mined + cells[id-boardWidth].mined + cells[id-1].mined;
				neighborList.push(cells[id-boardWidth-1], cells[id-boardWidth], cells[id-1]);

			}
			else if(id % boardWidth == 0)	//5 neighbors
			{
				neighbor = 5;
				num = cells[id-boardWidth].mined + cells[id-boardWidth+1].mined + cells[id+1].mined + cells[id+boardWidth].mined + cells[id+boardWidth+1].mined;
				neighborList.push(cells[id-boardWidth], cells[id-boardWidth+1], cells[id+1], cells[id+boardWidth], cells[id+boardWidth+1]);

			}
			else if(id < boardWidth)
			{
				neighbor = 5;
				num = cells[id-1].mined + cells[id+1].mined + cells[id+boardWidth-1].mined + cells[id+boardWidth].mined + cells[id+boardWidth+1].mined;
				neighborList.push(cells[id-1], cells[id+1], cells[id+boardWidth-1], cells[id+boardWidth], cells[id+boardWidth+1]);
				
			}
			else if(id % boardWidth == boardWidth - 1)
			{
				neighbor = 5;
				num = cells[id-boardWidth-1].mined + cells[id-boardWidth].mined + cells[id-1].mined + cells[id+boardWidth-1].mined + cells[id+boardWidth].mined;
				neighborList.push(cells[id-boardWidth-1], cells[id-boardWidth], cells[id-1], cells[id+boardWidth-1], cells[id+boardWidth]);
				
			}
			else if(id > boardWidth*boardHeight - boardWidth)
			{
				neighbor = 5;
				num = cells[id-boardWidth-1].mined + cells[id-boardWidth].mined + cells[id-boardWidth+1].mined + cells[id-1].mined + cells[id+1].mined;
				neighborList.push(cells[id-boardWidth-1], cells[id-boardWidth], cells[id-boardWidth+1], cells[id-1], cells[id+1]);
				
			}
			else	//8 neighbors
			{
				neighbor = 8;
				num = cells[id-boardWidth-1].mined + cells[id-boardWidth].mined + cells[id-boardWidth+1].mined + cells[id-1].mined + cells[id+1].mined + cells[id+boardWidth-1].mined + cells[id+boardWidth].mined + cells[id+boardWidth+1].mined;
				neighborList.push(cells[id-boardWidth-1], cells[id-boardWidth], cells[id-boardWidth+1], cells[id-1], cells[id+1], cells[id+boardWidth-1], cells[id+boardWidth], cells[id+boardWidth+1]);
				
			}
			
			cells[id].numOfMine = num;
			
			return neighborList;
			
		}
		
		public function restart(event:MouseEvent):void
		{
			//trace("restart");
			remainingMine = totalMine;
			remainingMineText.text = "Mines left: " + remainingMine.toString();
			
			numOfRevealed = 0;
			
			removeChild(board);
			board = new Sprite();
			addChildAt(board, 0);
			cells = new Array();
			
			generateBoard(0,0,boardWidth,boardHeight);
			plantMine();
			placeNumbers();
		}
	}	//end of class
	
	
}	//end of package