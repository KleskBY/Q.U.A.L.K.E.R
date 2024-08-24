
//////////////////////////////////////////////
/////////////////    FENCE   /////////////////
//////////////////////////////////////////////

// Opaque texture with see-through holes knocked in in.
textures/stalker/mtl/mtl_fence2
{
	surfaceParm trans
    surfaceparm metalsteps
	surfaceparm noimpact
    cull none
	qer_alphaFunc gequal 0.5

    // A GRATE OR GRILL THAT CAN BE SEEN FROM BOTH SIDES
    {
        map textures/stalker/mtl/mtl_fence2.tga
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}

textures/stalker/mtl/mtl_fence2n
{
	surfaceParm trans
    surfaceparm metalsteps
	surfaceparm noimpact
	cull none
    {
        map textures/stalker/mtl/mtl_fence2n.tga
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}

textures/stalker/mtl/mtl_girder_reil
{
	surfaceParm trans
    surfaceparm metalsteps
	surfaceparm noimpact
	cull back
    {
        map textures/stalker/mtl/mtl_girder_reil
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}

textures/stalker/mtl/mtl_girder_reil_a
{
	surfaceParm trans
    surfaceparm metalsteps
	surfaceparm noimpact
	cull back
    {
        map textures/stalker/mtl/mtl_girder_reil
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}

textures/stalker/mtl/mtl_fence_01
{
	surfaceParm trans
    surfaceparm metalsteps
	surfaceparm noimpact
	cull back
    {
        map textures/stalker/mtl/mtl_fence_01
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}

textures/stalker/prop/prop_zabor_iov
{
	surfaceParm trans
    surfaceparm metalsteps
	surfaceparm noimpact
	cull back
    {
        map textures/stalker/prop/prop_zabor_iov
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}

textures/stalker/mtl/mtl_resh_reil
{
	surfaceParm trans
    surfaceparm metalsteps
	surfaceparm noimpact
	cull back
    {
        map textures/stalker/mtl/mtl_resh_reil
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}

textures/stalker/prop/prop_grate2
{
	surfaceParm trans
    surfaceparm metalsteps
    cull none

    // A GRATE OR GRILL THAT CAN BE SEEN FROM BOTH SIDES
    {
        map textures/stalker/prop/prop_grate2.tga
        blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
        alphaFunc GT0
        depthWrite
        rgbGen identity
    }
    {
        map $lightmap
        rgbGen identity
        blendFunc GL_DST_COLOR GL_ZERO
        depthFunc equal
    }
}



//////////////////////////////////////////////
/////////////////    GLASS   /////////////////
//////////////////////////////////////////////

textures/stalker/glas/glas_lab
{
   surfaceParm trans
   qer_editorimage textures/Q_glass/glass3
   qer_trans 0.25
   //surfaceparm nolightmap
   //surfaceparm nodlight
   alphaFunc GE128
   surfaceparm detail
   {
      map textures/stalker/glas/glas_lab
      blendfunc filter
      rgbGen identity
	  //tcGen environment
	  //dp_reflect 0.1
   }
}

//////////////////////////////////////////////
/////////////////    WATER   /////////////////
//////////////////////////////////////////////

textures/stalker/water/water_studen
{
	qer_editorimage textures/stalker/water/water_studen
	qer_trans 0.25
	
	surfaceparm nonsolid
	surfaceParm trans
	surfaceparm nolightmap
	//surfaceparm nodlight
	alphaFunc GE128
	surfaceparm detail
	surfaceparm water
	deformVertexes wave 5 sin 0 3.25 0 .1
	{
		map textures/stalker/water/water_studen
		blendfunc GL_SRC_ALPHA GL_ONE
		tcMod turb 0 0.1 0 0.04
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		rgbGen vertex		
	}
}







//////////////////////////////////////////////
/////////////////    TREES   /////////////////
//////////////////////////////////////////////

textures/stalker/trees/trees_bark_a_01
{
	surfaceparm nonsolid
	{
		map textures/stalker/trees/trees_bark_a_01
		rgbGen vertex
	}
}

//////////////////////////////////////////////
/////////////////    SKY   ///////////////////
//////////////////////////////////////////////

textures/p2_sky_day
{
	surfaceparm noimpact
	surfaceparm nolightmap
	surfaceparm nomarks
	surfaceparm sky
	dp_noshadow
	q3map_sun .9 .9 1 70 45 30
	q3map_surfacelight 70
	skyparms env/p2_sky_day 1024 -
}





//////////////////////////////////////////////
/////////////////    GRASS   /////////////////
//////////////////////////////////////////////


textures/stalker/trees/trees_vetkasux2
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	//deformVertexes autoSprite //look into camera
	{
		map textures/stalker/trees/trees_vetkasux2
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}

textures/stalker/trees/trees_kamish_sux
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_kamish_sux
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}

textures/stalker/trees/trees_vetkagreen1
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_vetkagreen1
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}

textures/stalker/trees/trees_vetkagreen3
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_vetkagreen3
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}

textures/stalker/trees/trees_vetkagreen5
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_vetkagreen5
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}

textures/stalker/trees/trees_vetkasux2
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_vetkasux2
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}



textures/stalker/trees/trees_vetkabig
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_vetkabig
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}


textures/stalker/trees/trees_sosna_sux
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_sosna_sux
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}


textures/stalker/trees/trees_sosna
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_sosna
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}


textures/stalker/trees/trees_osoka_sux
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_osoka_sux
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}


textures/stalker/trees/trees_kamish_sux
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_kamish_sux
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}

textures/stalker/trees/trees_elka
{
	surfaceparm alphashadow
	surfaceparm nonsolid
	surfaceparm nomarks
	surfaceparm noimpact
	surfaceparm nolightmap
	nopicmip
	dp_noshadow
	
	cull back
	surfaceparm trans 
	deformVertexes wave 15 sin 0 2 0 .1 //animation
	{
		map textures/stalker/trees/trees_kamish_sux
		rgbGen vertex
		depthWrite
		alphaFunc GE128
	}
}