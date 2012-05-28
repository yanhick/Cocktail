/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktail.core.renderer;

import cocktail.core.background.BackgroundManager;
import cocktail.core.dom.Node;
import cocktail.core.html.HTMLElement;
import cocktail.core.NativeElement;
import cocktail.core.geom.GeomData;
import cocktail.core.style.formatter.BlockFormattingContext;
import cocktail.core.style.formatter.FormattingContext;
import cocktail.core.style.StyleData;
import cocktail.core.style.CoreStyle;
import flash.display.Sprite;
import flash.Lib;
import haxe.Log;
import haxe.Timer;

/**
 * This is the root ElementRenderer of the ElementRenderer
 * tree, generated by the HTMLBodyElement, which is the root
 * of the DOM tree
 * 
 * TODO 3 : update doc
 * 
 * @author Yannick DOMINGUEZ
 */
class InitialBlockRenderer extends BlockBoxRenderer
{
	/**
	 * class constructor.
	 */
	public function new(node:Node) 
	{
		super(node);
		
		//call the attachement method itself as it is 
		//supposed to be called by parent ElementRenderer
		//otherwise
		attachLayer();
	}
	

	//TODO 2 : shouldn't have to override this, should use other method, like
	//establishes new stacking context
	override public function attachLayer():Void
	{
		_layerRenderer = new LayerRenderer(this);
		
		for (i in 0..._childNodes.length)
		{
			var child:ElementRenderer = cast(_childNodes[i]);
			child.attachLayer();
		}
	}
	
		//TODO 2 : shouldn't have to override this, should use other method, like
	//establishes new stacking context
	override public function detachLayer():Void
	{
		//first detach the LayerRenderer of all its children
		for (i in 0..._childNodes.length)
		{
			var child:ElementRenderer = cast(_childNodes[i]);
			child.detachLayer();
		}
		
		//only detach the LayerRenderer if this ElementRenderer
		//created it, else it will be detached by the ElementRenderer
		//which created it when detached

			
		
		
		_layerRenderer = null;
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PUBLIC INVALIDATION METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The initial block renderer doesn't have a parent, so when invalidated,
	 * it always starts a layout
	 */
	override public function invalidateLayout(immediate:Bool = false):Void
	{
		//don't call if the body has already scheduled a layout, unless
		//an immediate layout is required
		if (this._isLayingOut == false || immediate == true)
		{
			this._isLayingOut = true;
			doInvalidate(immediate);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// PUBLIC METHOD
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The Document is invalidated for instance when the
	 * DOM changes after adding/removing a child or when
	 * a style changes.
	 * When this happen, the Document needs to be layout
	 * and rendered again
	 * 
	 * @param immediate define wether the layout must be synchronous
	 * or asynchronous
	 */
	private function doInvalidate(immediate:Bool = false):Void
	{
		//either schedule an asynchronous layout and rendering, or layout
		//and render immediately
		if (immediate == false)
		{
			scheduleLayoutAndRender();
		}
		else
		{
			layoutAndRender();
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// PRIVATE RENDERING METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * As the name implies,
	 * layout the DOM, then render it
	 */
	private function layoutAndRender():Void
	{
		startLayout();
		startRendering();
	}
	
	/**
	 * Start the rendering of the rendering tree
	 * built during layout
	 * and attach the resulting nativeElements (background,
	 * border, embedded asset...) to the display root
	 * of the runtime (for instance the Stage in Flash)
	 */ 
	private function startRendering():Void
	{
		trace("start rendering");
		#if (flash9 || nme)
		
		//start the rendering at the root layer renderer
		//TODO 3 : should instead call an invalidateRendering method on LayerRenderer ?
		render(Lib.current, { x:0.0, y:0.0 } );

		#end
	}
	
	/**
	 * Set a timer to trigger a layout and rendering of the HTML Document asynchronously.
	 * Setting a timer to execute the layout and rendering ensure that the layout only happen once when a series of style
	 * values are set or when many elements are attached/removed from the DOM, instead of happening for every change.
	 */
	private function scheduleLayoutAndRender():Void
	{
		var layoutAndRenderDelegate:Void->Void = layoutAndRender;
		
		//calling the methods 1 millisecond later is enough to ensure
		//that first all synchronous code is executed
		Timer.delay(function () { 
			layoutAndRenderDelegate();
		}, 1);
	}
	
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE LAYOUT METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Overriden as the initial ElementRenderer always layout its positioned children as it is the root of the rendering tree
	 */
	override private function layoutAbsolutelyPositionedChildrenIfNeeded(childrenFirstPositionedAncestorData:FirstPositionedAncestorData, viewportData:ContainingBlockData):Void
	{
		for (i in 0...childrenFirstPositionedAncestorData.elements.length)
		{
			var element:ElementRenderer = childrenFirstPositionedAncestorData.elements[i];
			//use the viewport dimensions both times
			layoutPositionedChild(element, childrenFirstPositionedAncestorData.data, viewportData);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PUBLIC HELPER METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * The initial block container always establishes a block formatting context
	 * for its children
	 */
	override public function establishesNewFormattingContext():Bool
	{
		return true;
	}
	
	/**
	 * Overriden as initial block container alwyas establishes a new
	 * stacking context and creates the root LayerRenderer of the
	 * LayerRenderer tree
	 */
	override public function establishesNewStackingContext():Bool
	{
		return true;
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE HELPER METHODS
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * When dispatched on the HTMLBodyElement,
	 * the scroll event must bubble to be dispatched
	 * on the Document and Window objects
	 */
	override private function mustBubbleScrollEvent():Bool
	{
		return true;
	}
	
	/**
	 * A computed value of visible for the overflow on the initial
	 * block renderer is the same as auto, as it is likely that
	 * scrollbar must be displayed to scroll through the document
	 */
	override private function treatVisibleOverflowAsAuto():Bool
	{
		return true;
	}
	
	/**
	 * Retrieve the dimension of the Window
	 */
	override private function getWindowData():ContainingBlockData
	{	
		var windowData:ContainingBlockData = {
			isHeightAuto:false,
			isWidthAuto:false,
			width:cocktail.Lib.window.innerWidth,
			height:cocktail.Lib.window.innerHeight
		}
		
		//scrollbars dimension are removed from the Window dimension
		//if displayed to return the actual available space
		//
		//TODO 5 : should implement outerHeight and outerWidth ?
		//TODO 2 : rendering not exact with vertical scrollbar
		if (_verticalScrollBar != null)
		{
			windowData.width -= _verticalScrollBar.coreStyle.computedStyle.width;
		}
		
		if (_horizontalScrollBar != null)
		{
			windowData.height -= _horizontalScrollBar.coreStyle.computedStyle.height;
		}
		
		return windowData;
	}
	
	/**
	 * The dimensions of the initial
	 * block renderer are always the same as the Window
	 * 
	 * TODO 2 : on initial layout, computedStyles for margin are null,
	 * there should be a special case for the initial block renderer where
	 * its styles are computed before layout. Should ContainingBlockData height
	 * return height of body or viewport ?
	 */
	override private function getContainerBlockData():ContainingBlockData
	{
		var windowData:ContainingBlockData = getWindowData();
		
		windowData.width -= computedStyle.marginLeft + computedStyle.marginRight;
		windowData.height -= computedStyle.marginTop + computedStyle.marginBottom;
		
		return windowData;
	}
	
	/**
	 * The initial ElementRenderer is always a block container
	 */
	override public function isInlineLevel():Bool
	{
		return false;
	}
	
	/**
	 * The root of the runtime always starts a block formatting context
	 */
	override private function getFormattingContext(previousformattingContext:FormattingContext):FormattingContext
	{
		return new BlockFormattingContext(this);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN GETTER
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * overriden as the bounds of the initial block container
	 * are always the them as the Window (minus scrollbars dimensions
	 * if displayed)
	 * 
	 * TODO 3 : shouldn't the width and height instead be the bounds
	 * of the children ?
	 */
	override private function get_bounds():RectangleData
	{
		var containerBlockData:ContainingBlockData = getContainerBlockData();
		
		var width:Float = containerBlockData.width;
		var height:Float = containerBlockData.height;
		
		return {
			x:0.0,
			y:0.0,
			width:width,
			height:height
		};
	}
	
	/**
	 * For the initial container, the bounds and
	 * global bounds are the same
	 */
	override private function get_globalBounds():RectangleData
	{
		return get_bounds();
	}
	
}