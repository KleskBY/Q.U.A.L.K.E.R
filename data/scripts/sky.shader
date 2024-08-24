

textures/sky
{
	qer_editorimage env/sky_bk
	surfaceparm noimpact
	surfaceparm nomarks
	surfaceparm nolightmap
	surfaceparm sky
	nopicmip
	nomipmaps
	
	q3map_sun 1.15 .52 0.53 75 45 30
	q3map_surfacelight 55
	skyparms env/sky - -
}

textures/sky_grey
{
	qer_editorimage env/sky_bk
	surfaceparm noimpact
	surfaceparm nomarks
	surfaceparm nolightmap
	surfaceparm sky
	nopicmip
	nomipmaps
	
	//q3map_sun 1 1 0.5 150 30 60
	q3map_sun .9 .9 1 70 45 30
	//q3map_sun .8 .82 0.83 75 45 30
	q3map_surfacelight 45
	skyparms env/sky - -
}

textures/sky_test
{
	surfaceparm noimpact
	surfaceparm nomarks
	surfaceparm nolightmap
	surfaceparm sky
	nopicmip
	nomipmaps
	
	q3map_sun .8 .82 0.83 75 45 30
	q3map_surfacelight 45
	skyparms lolg - -
}
