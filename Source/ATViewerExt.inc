procedure ATViewerOptionsReset;
begin
  with ATViewerOptions do
  begin
    ExtText := '';
    ExtRTF := 'rtf';

    ExtImages :=
      'bmp,ico,wmf,emf,jpg,jpeg,jpe,jfif,png,gif,rle,dib'
      + ',tga,tif,tiff,psd,fax,eps,icb,win,vst,vda'
      + ',pcx,pcc,rpf,rla,sgi,rgba,rgb,bw,pdd,ppm,pgm,pbm,cel,pic,pcd,cut,pal,psp'
      + ',jp2,jpc,pnm,ras,mis' //Jasper
      + ',ani,cur';

    ExtInet :=
      'htm,html,xml,xsl,mht' //MSIE
      + ',pdf,swf,xps' //Acrobat, Flash, MS XPS
      + ',shtml,xhtml,shtm,stm,php,php2,php3,asp,pl,vrml,plg,htt,htx'; //MSIE

    ExtImagesUse := True;
    ExtInetUse := True;
  end;
end;


const
  //Supported by IrfanView but without audio/media/icons
  cIViewDefaultExtensions =
    'aif,ani,cur,awd,b3d,bmp,dib,clp,dds,' +
    'acr,djvu,ecw,emf,wmf,eps,ps,fits,fpx,fsh,g3,gif,' +
    'hdr,icl,iff,lbm,img,gem,jpg,jp2,jpm,kdc,ldf,lwf,med,' +
    'mng,jng,ov,mrsid,nlm,nol,ngg,pbm,pgm,ppm,pcx,dcx,' +
    'photocd,png,psd,psp,pvr,ras,sun,raw,rle,sff,sfw,' +
    'sgi,rgb,tga,tif,tiff,ttf,wad,wbmp,xbm,xpm,crw,cr2,vtf,' +
    'dng,nef,orf,raf,mrw,dcr,x3f,pef,srf,eff,dxf,dwg,hpgl,cgm,svg';

  //ijl15.dll
  cIJLDefaultExtensions = 'jpg,jpeg,jpe,jfif';

  //Jasper
  cJp2DefaultExtensions = 'jp2,jpc,pnm,ras,mis';
