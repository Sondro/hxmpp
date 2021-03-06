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
package jabber.sasl;

/**
	DIGEST-MD5 SASL Mechanism (ftp://ietf.org//rfc/rfc2831.txt)
*/
class MD5Mechanism {
	
	public static inline var NAME = 'DIGEST-MD5';
	
	public var id(default,null) : String;
	public var serverType(default,null) : String;
	
	var username : String;
	var host : String;
	var pass : String;
	var resource : String;
	
	public function new( serverType : String = "xmpp" ) {
		this.id = NAME;
		this.serverType = serverType;
	}
	
	public function createAuthenticationText( username : String, host : String, pass : String, resource : String ) : String {
		this.username = username;
		this.host = host;
		this.pass = pass;
		this.resource = resource;
		return null;
	}
	
	public function createChallengeResponse( challenge : String ) : String {
		var c = MD5Calculator.parseChallenge( challenge );
		return (c == null) ? "" : MD5Calculator.createResponse( host, serverType, username, c.realm, pass, c.nonce );
	}
	
}
