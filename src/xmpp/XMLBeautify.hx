/*
 * Copyright (c) disktree.net
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package xmpp;

using Lambda;

/**
	Utility to beautify XML strings for human readability.
*/
class XMLBeautify {
	
	/**
		Format given xml string to something human readable.
	*/
	public static function beautify( s : String ) : String {
		var x : Xml = null;
		try x = Xml.parse(s).firstElement() catch(e:Dynamic) {
			return s;
		}
		if( x == null )
			return s;
		return beautifyXml(x);
	}

	/**
	*/
	public static function beautifyXml( x : Xml ) : String {
		var b = new StringBuf();
		createNode( x, b, 0 );
		return b.toString();
	}
	
	static function createNode( x : Xml, b : StringBuf, depth : Int ) {
		if( x == null )
			return;
		indent( b, depth );
		b.add( '<' );
		b.add( x.nodeName );
		for( a in x.attributes() ) {
			b.add( ' ' );
			b.add( a );
			b.add( '=' );
			b.add( '"' );
			b.add( x.get( a ) );
			b.add( '"' );
		}
		if( x.elements().hasNext() ) {
			b.add( '>\n' );
			for( e in x.elements() )
				createNode( e, b, depth+1 );
			indent( b, depth );
			b.add( '</' );
			b.add( x.nodeName );
			b.add( '>\n' );
		} else {
			var v = x.firstChild();
			if( v != null ) {
				b.add( '>' );
				b.add( v );
				b.add( '</' );
				b.add( x.nodeName );
				b.add( '>\n' );
			} else {
				b.add( '/>\n' );
			}
		}
	}
	
	static inline function indent( b : StringBuf, n : Int ) for( i in 0...n ) b.add( '\t' );

}
