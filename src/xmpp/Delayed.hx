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

using xmpp.XMLUtil;

typedef PacketDelay = {
	
	/**
		The Jabber ID of the entity that originally sent the XML stanza
		or that delayed the delivery of the stanza (e.g., the address of a multi-user chat room).
	*/
	var from : String;
	
	/**
		The time when the XML stanza was originally sent.
	*/
	var stamp : String;
	
	/**
		Description of the reason for the delay.
	*/
	var description : String;
}

/**
	XEP-0203: Delayed Delivery: http://xmpp.org/extensions/xep-0203.html
*/
class Delayed {
	
	public static inline var XMLNS = "urn:xmpp:delay";
	
	public var from : String;
	public var stamp : String;
	public var description : String;
	
	public function new( from : String, stamp : String, ?description : String ) {
		this.from = from;
		this.stamp = stamp;
		this.description = description;
	}
	
	public function toXml() : Xml {
		var x = IQ.createQueryXml( XMLNS, "delay" );
		x.set( "from", from );
		x.set( "stamp", stamp );
		if( description != null ) x.set( "description", description );
		return x;
	}

	/**
		Returns true if the xmpp given packet has a delay property
	*/
	public static function is( p : xmpp.Packet ) {
		for( x in p.properties ) {
			if( isDelayProperty( x ) )
				return true;
		}
		return false;
	}
	
	/**
		Parses/Returns the packet delay from the properties of the given XMPP packet.
	*/
	public static function fromPacket( p : xmpp.Packet ) : xmpp.PacketDelay {
		for( x in p.properties ) {
			if( isDelayProperty(x) )
				return parseDelay( x );
		}
		return null;
	}

	/**
	*/
	public static function isDelayProperty( x : Xml ) : Bool {
		var s = x.get( "xmlns" );
		if( x.nodeName == "delay" && s == XMLNS )
			return true;
		return ( x.nodeName == "x" && s == "jabber:x:delay" );
	}
	
	static inline function parseDelay( x : Xml ) : xmpp.PacketDelay {
		return { from : x.get( "from" ),
				 stamp : x.get( "stamp" ),
				 description : (x.firstChild() != null) ? x.firstChild().nodeValue : null };
	}

}
