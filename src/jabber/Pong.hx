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
package jabber;

/**
	XEP 199 - XMPP Ping: http://www.xmpp.org/extensions/xep-0199.html
	Listens for incoming ping messages and automaticly responds with a pong.
*/
class Pong {
	
	/** Informational callback on ping-pong */
	public dynamic function onPong( jid : String ) {}

	public var stream(default,null) : Stream;
	
	var c : PacketCollector;
	
	public function new( stream : Stream ) {
		
		if( !stream.features.add( xmpp.Ping.XMLNS ) )
			throw "Ping listener already added";

		this.stream = stream;

		c = stream.collectPacket( [new xmpp.filter.IQFilter( xmpp.Ping.XMLNS, get )], handlePing, true );
	}
	
	public function dispose() {
		if( c == null )
			return;
		stream.features.remove( xmpp.Ping.XMLNS );
		stream.removeCollector(c);
		c = null;
	}
	
	function handlePing( iq : xmpp.IQ ) {
		var r = xmpp.IQ.createResult( iq );
		r.properties.push( xmpp.Ping.createXml() );
		stream.send( r.toString() );
		onPong( iq.from );
	}
		
}
