package gfx;

import lime.graphics.Image;
import lime.graphics.WebGL2RenderContext;
import lime.graphics.WebGLRenderContext;
import lime.math.Matrix4;
import lime.math.Rectangle;
import lime.math.Vector2;
import lime.utils.Assets;

import gfx.Color;

/**
 * ...
 * @author Matthias Faust
 */
class Gfx {
	public static var gl:WebGLRenderContext;
	
	private static var _shader:Shader;
	
	public static var _texture:Texture;
	private static var _textureDefault:Texture;
	
	public static var _defaultImage1:Image;
	public static var _defaultImage2:Image;
	
	private static var _matrix:Matrix4;
	private static var _batch:Batch;
	private static var _color:Color = Color.WHITE;
	
	private static var _width:Int;
	private static var _height:Int;
	private static var _offsetX:Int = 0;
	private static var _offsetY:Int = 0;
	
	public static inline function setup(w:Int, h:Int) {
		_width = w;
		_height = h;
		
		_matrix = new Matrix4();
		_matrix.createOrtho(0, w, h, 0, -1000, 1000);
	}
	
	public static inline function begin(batch:Batch) {
		_batch = batch;
		_batch.clear();
	}
	
	public static inline function end() {
		_batch.bind();
		_batch.draw();
	}
	
	public static inline function setColor(color:Color) {
		_color = color;
	}
	
	public static function resetTexture() {
		if (_textureDefault != null) _texture = _textureDefault;
	}
	
	public static function loadTexture(fileName:String, ?extraName:String = null) {
		var texture:Texture = new Texture();
		
		var img1:Image = Assets.getImage(fileName);
		_defaultImage1 = img1;
		
		var img2:Image = null;
		if (extraName != null) img2 = Assets.getImage(extraName);
		
		var img:Image = new Image(null, 0, 0, 256, 2 * 512);
		img.copyPixels(img1, new Rectangle(0, 0, 256, 512), new Vector2(0, 0));
		
		if (img2 != null) {
			img.copyPixels(img2, new Rectangle(0, 0, 256, 512), new Vector2(0, 512));
			_defaultImage2 = img2;
		}
		
		texture.createFromImage(img);
		
		if (texture != null) {
			_texture = texture;
			_textureDefault = texture;
		}
		
		return texture;
	}
	
	public static function loadTextureFrom(img1:Image, ?img2:Image = null) {
		var texture:Texture = new Texture();
		
		var image:Image = new Image(null, 0, 0, 256, 2 * 512);
		if (img1 != null) {
			image.copyPixels(img1, new Rectangle(0, 0, 256, 512), new Vector2(0, 0));
		} else {
			image.copyPixels(Gfx._defaultImage1, new Rectangle(0, 0, 256, 512), new Vector2(0, 0));
		}
		
		if (img2 != null) {
			image.copyPixels(img2, new Rectangle(0, 0, 256, 512), new Vector2(0, 512));
		} else {
			image.copyPixels(Gfx._defaultImage2, new Rectangle(0, 0, 256, 512), new Vector2(0, 512));
		}
		
		if (image != null) {
			texture.createFromImage(image);
		
			if (texture != null) {
				_texture = texture;
			}
		} else {
			trace("image is null!");
		}
		
		return texture;
	}
	
	public static inline function setTexture(texture:Texture) {
		if (_shader == null) {
			trace("setTexture() -> No shader in use!");
			return;
		}
		
		_texture = texture;
		
		texture.bind();
		gl.uniform1i(_shader.u_Texture0, 0);
	}
	
	public static inline function setShader(shader:Shader) {
		_shader = shader;
		shader.use();
	}
	
	public static inline function setOffset(x:Int, y:Int) {
		_offsetX = x;
		_offsetY = y;
	}
	
	public static inline function setViewport(x:Int, y:Int, w:Int, h:Int) {
		if (_matrix == null) {
			trace("setViewport() -> No matrix!");
			return;
		}
		
		if (_shader == null) {
			trace("setViewport() -> No shader in use!");
			return;
		}
		
		// gl.uniformMatrix4fv(_shader.u_camMatrix, 1, false, _matrix);
		gl.uniformMatrix4fv(_shader.u_camMatrix, false, _matrix);
		gl.viewport(x, y, w, h);
	}
	
	public static function clear(color:Color) {
		gl.clearColor(color.r, color.g, color.b, color.a);
		gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
	}
	
	public static inline function drawTexture(x:Float, y:Float, w:Float, h:Float, rect:Rectangle, ?color:Color = null) {
		if (_batch == null) {
			trace("GFX ERROR: No batch bound!");
			return;
		}
		
		if (color == null) color = _color;
		
		_batch.pushVertex(
			_offsetX + x, 
			_offsetY + y, 			
			rect.left, rect.top, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.pushVertex(
			_offsetX + x, 
			_offsetY + y + h, 		
			rect.left, rect.bottom, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.pushVertex(
			_offsetX + x + w, 
			_offsetY + y + h, 	
			rect.right, rect.bottom, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.pushVertex(
			_offsetX + x + w, 
			_offsetY + y, 		
			rect.right, rect.top, 	
			color.r, color.g, color.b, color.a
		);
		
		_batch.addIndices([0, 1, 2, 2, 3, 0]);
	}
	
	public static inline function drawSprite(x:Float, y:Float, spr:Sprite, ?color:Color = null) {
		if (color == null) {
			if (spr.color != null) color = spr.color;
		}
		
		drawTexture(Std.int(x), Std.int(y), spr.width, spr.height, spr.uv, color);
	}
	
	public static inline function getSprite(x:Int, y:Int, ?w:Int = -1, ?h:Int = -1):Sprite {
		/*
		if (_texture == null) {
			trace("getSprite(): No texture loaded!");
			return null;
		}
		*/
		
		if (w == -1 || h == -1) {
			return new Sprite(_texture, x, y, Tobor.TILE_WIDTH, Tobor.TILE_HEIGHT);
		} else {
			return new Sprite(_texture, x, y, w, h);
		}
	}
	
	public static function getSprites(list:Array<Sprite>, x:Int, y:Int, start:Int, count:Int):Array<Sprite> {
		if (list == null) {
			list = [];
		}
		
		for (i in start ... count) {
			list.push(Gfx.getSprite(x + 16 * i, y));
		}
		
		return list;
	}
}