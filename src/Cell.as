package
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	public class Cell extends SimpleButton
	{
		public var up:Sprite = new Sprite();
		public var down:Sprite = new Sprite();	
		public var over:Sprite = new Sprite();
		public var shift:Sprite = new Sprite();
		public var click:Sprite = new Sprite();
		public var gameOver:Sprite = new Sprite();
		
		public var mined:Boolean;
		public var revealed:Boolean;
		public var marked:Boolean;
		public var xcoord:uint;
		public var ycoord:uint;
		public var numOfMine:int;
		
		public var cellLabel:TextField;
	
		public function Cell(coordinateX:uint, coordinateY:uint, cellSize:uint)
		{
			
			mined = false;
			numOfMine = 1;
			this.xcoord = coordinateX;
			this.ycoord = coordinateY;
			
			up.graphics.lineStyle(1, 0x000000);
			up.graphics.beginFill(0xBB0000);
			up.graphics.drawRect(coordinateX, coordinateY, cellSize, cellSize);
			
			down.graphics.lineStyle(1, 0x0000);
			down.graphics.beginFill(0xFFBB00);
			down.graphics.drawRect(coordinateX, coordinateY, cellSize, cellSize);
			
			over.graphics.lineStyle(1, 0x000000);
			over.graphics.beginFill(0xFFFF00);
			over.graphics.drawRect(coordinateX, coordinateY, cellSize, cellSize);
			
			shift.graphics.lineStyle(1, 0x000000);
			shift.graphics.beginFill(0x000000);
			shift.graphics.drawRect(coordinateX, coordinateY, cellSize, cellSize);
			
			click.graphics.lineStyle(1, 0x000000);
			click.graphics.beginFill(0xFFFFCC);
			click.graphics.drawRect(coordinateX, coordinateY, cellSize, cellSize);
			
			gameOver.graphics.lineStyle(1, 0x000000);
			gameOver.graphics.beginFill(0xFFFFCC);
			gameOver.graphics.drawRect(0, 0, 300, 300);

			cellLabel = new TextField();
			cellLabel.text = numOfMine.toString();
			cellLabel.x = coordinateX + (click.width)/4;
			cellLabel.y = coordinateY + (click.height)/16;
			click.addChild(cellLabel);

			this.addEventListener(MouseEvent.CLICK, clicked);
			this.upState = up;
			this.downState = down;
			this.overState = over;
			this.useHandCursor = true;
			this.hitTestState = up;

		}

		private function clicked(event:MouseEvent):void
		{
			if(event.shiftKey)	//shift+click represents right click here
			{
				if(this.revealed)
				{
					//remain the same
				}
				else if(this.marked)
				{
					this.marked = false;
					MineSweeper(this.parent).remainingMine = MineSweeper(this.parent).remainingMine + 1;
					MineSweeper(this.parent).remainingMineText.text = "Mines left: " + MineSweeper(this.parent).remainingMine.toString();
					
					this.upState = up;
					this.overState = over;
					this.downState = down;
					
				}
				else
				{
					this.marked = true;
					MineSweeper(this.parent).remainingMine = MineSweeper(this.parent).remainingMine - 1;
					MineSweeper(this.parent).remainingMineText.text = "Mines left: " + MineSweeper(this.parent).remainingMine.toString();
					
					this.upState = shift;
					this.overState = shift;
					this.downState = shift;
				}
			}
			else	//click
			{
				if(this.mined)
				{
					trace("Game over");

					MineSweeper(this.parent).board.graphics.lineStyle(1, 0x000000);
					MineSweeper(this.parent).board.graphics.beginFill(0xFFFF00);
					MineSweeper(this.parent).board.graphics.drawRect(0, 0, 300, 300);
					
					var gameOverLabel:TextField = new TextField();
					
					gameOverLabel.text = "GAME OVER!!";
			
					gameOverLabel.width = 500;
					gameOverLabel.height = 500;
					
					gameOverLabel.x = 120;
					gameOverLabel.y = 120;
					MineSweeper(this.parent).board.addChild(gameOverLabel);
					
					MineSweeper(this.parent).addChild(MineSweeper(this.parent).board);
					MineSweeper(this.parent).addChild(MineSweeper(this.parent).restartButton);
					//MineSweeper(this.parent).restartButton.addEventListener(MouseEvent.CLICK, MineSweeper(this.parent).restart);
					
				}
				else if(this.revealed || this.marked)
				{
					//remain the same
				}
				else
				{
					revealCell();
				}
				
			}
			
			if(MineSweeper(this.parent).numOfRevealed == MineSweeper(this.parent).boardWidth*MineSweeper(this.parent).boardHeight-MineSweeper(this.parent).totalMine && MineSweeper(this.parent).remainingMine == 0)
			{
				trace("WIN");
				
				MineSweeper(this.parent).board.graphics.lineStyle(1, 0x000000);
				MineSweeper(this.parent).board.graphics.beginFill(0xFFFF00);
				MineSweeper(this.parent).board.graphics.drawRect(0, 0, 300, 300);
				
				var winLabel:TextField = new TextField();
				
				winLabel.text = "YOU WIN!!";
				
				winLabel.width = 500;
				winLabel.height = 500;
				
				winLabel.x = 120;
				winLabel.y = 120;
				MineSweeper(this.parent).board.addChild(winLabel);
				
				MineSweeper(this.parent).addChild(MineSweeper(this.parent).board);
				MineSweeper(this.parent).addChild(MineSweeper(this.parent).restartButton);
			}
			
		}
		
		private function revealCell():void
		{
			this.revealed = true;
			MineSweeper(this.parent).numOfRevealed = MineSweeper(this.parent).numOfRevealed + 1;
			
			this.upState = click;
			this.overState = click;
			this.downState = click;
			
			if(this.numOfMine == 0)
			{ 
				autoReveal();
			}
		}
		
		private function autoReveal():void
		{
			var neighbors:Array = MineSweeper(this.parent).getListOfMine(this);
			
			for (var index:int in neighbors) 
			{
				if(!neighbors[index].revealed)
				{ 
					neighbors[index].revealCell(); 
				}
			}

		}
		
	}
}