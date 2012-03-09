/*
	This file is part of Cocktail http://www.silexlabs.org/groups/labs/cocktail/
	This project is © 2010-2011 Silex Labs and is released under the GPL License:
	This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later version. 
	This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
	To read the license please visit http://www.gnu.org/copyleft/gpl.html
*/
package cocktailCore.style.as3;

import cocktail.domElement.DOMElement;
import cocktail.nativeElement.NativeElement;
import cocktailCore.style.abstract.AbstractBodyStyle;
import flash.Lib;
import haxe.Log;

/**
 * This is the Flash AS3 implementation of the BodyStyle
 * 
 * @author Yannick DOMINGUEZ
 */
class BodyStyle extends AbstractBodyStyle
{
	/**
	 * class constructor
	 * @param	domElement
	 */
	public function new(domElement:DOMElement) 
	{
		super(domElement);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////
	// OVERRIDEN PRIVATE RENDERING METHODS
	// The body attach/detach its children from the flash Stage
	//////////////////////////////////////////////////////////////////////////////////////////
	

	override private function attachNativeElement(nativeElement:NativeElement):Void
	{
		Lib.current.addChild(nativeElement);
	}
	
	override private function detachNativeElement(nativeElement:NativeElement):Void
	{
		//TODO : shouldn't have to check
		if (Lib.current.contains(nativeElement) == true)
		{
			Lib.current.removeChild(nativeElement);
		}
	}
	
}