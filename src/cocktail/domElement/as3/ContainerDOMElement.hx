/*
This file is part of Silex - see http://projects.silexlabs.org/?/silex

Silex is © 2010-2011 Silex Labs and is released under the GPL License:

This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktail.domElement.as3;
import cocktail.domElement.abstract.AbstractDOMElement;
import cocktail.nativeElement.NativeElement;
import cocktail.domElement.abstract.AbstractContainerDOMElement;
import flash.text.engine.BreakOpportunity;
import flash.text.engine.CFFHinting;
import flash.text.engine.ContentElement;
import flash.text.engine.ElementFormat;
import flash.text.engine.FontDescription;
import flash.text.engine.FontPosture;
import flash.text.engine.FontWeight;
import flash.text.engine.GroupElement;
import flash.text.engine.LineJustification;
import flash.text.engine.SpaceJustifier;
import flash.text.engine.TextBaseline;
import flash.text.engine.TextBlock;
import flash.text.engine.TextElement;
import flash.text.engine.TextLine;
import cocktail.style.StyleData;
import flash.text.engine.TypographicCase;
import flash.Vector;
import haxe.Log;

/**
 * This is the Flash AS3 implementation of the container DOMElement.
 * 
 * @author Yannick DOMINGUEZ
 */
class ContainerDOMElement extends AbstractContainerDOMElement
{
	/**
	 * class constructor
	 */
	public function new(nativeElement:NativeElement = null) 
	{
		super(nativeElement);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Override public method to manipulate the DOM
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Overriden to add the native flash display object as a 
	 * child of the native display object of this container
	 * @param domElement the flash display object to add to this 
	 * container
	 */
	override public function addChild(domElement:DOMElement):Void
	{
		super.addChild(domElement);
		this._nativeElement.addChild(domElement.nativeElement);
	}
	
	/**
	 * Overriden to remove the native flash display object from
	 * the native display object of this container
	 * @param domElement the flash display object to remove from
	 * this container
	 */
	override public function removeChild(domElement:DOMElement):Void
	{
		super.removeChild(domElement);
		this._nativeElement.removeChild(domElement.nativeElement);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN TEXT FRAGMENT MANAGEMENT methods
	//////////////////////////////////////////////////////////////////////////////////////////
	
	/**
	 * Attach the native flash TextLine object to this DOMElement native DisplayObjectContainer
	 */
	override public function addTextFragment(textFragmentDOMElement:TextFragmentDOMElement):Void
	{
		super.addTextFragment(textFragmentDOMElement);
		this._nativeElement.addChild(textFragmentDOMElement.nativeElement);
	}
	
	/**
	 * Removes the native flash TextLine object from this DOMElement native DisplayObjectContainer
	 */
	override private function removeTextFragment(textFragmentDOMElement:TextFragmentDOMElement):Void
	{		
		super.removeTextFragment(textFragmentDOMElement);
		
		if (textFragmentDOMElement != null)
		{
			this._nativeElement.removeChild(textFragmentDOMElement.nativeElement);
		}
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// Overriden getter/setter
	// The width and height setter/getter are overriden to prevent setting the width and height
	// of the native Flash DisplayObjectContainer. In as3, when the width or height is set on a
	// container, the content of the container is scaled
	//////////////////////////////////////////////////////////////////////////////////////////
	
	override private function setWidth(value:Int):Int
	{
		this._width = value;
		return this._width;
	}
	
	override private function setHeight(value:Int):Int
	{
		this._height = value;
		return this._height;
	}
	
}