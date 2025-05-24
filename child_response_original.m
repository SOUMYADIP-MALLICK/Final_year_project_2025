fmdl = mdl_normalize(mk_library_model('neonate_16el'),1);
[fmdl.stimulation,fmdl.meas_select] = mk_stim_patterns(16,1,'{ad}','{ad}');
opt.imgsz = [64 64]; opt.noise_figure = 0.5;
imdl = mk_GREIT_model(mk_image(fmdl,1), 0.25, [], opt);

vv= eidors_readdata('P04P-1016.get'); vi=vv(:,45); vh=vv(:,61);
imr = inv_solve(imdl,vh,vi);

clf;
imr.calc_colours = struct('ref_level',0,'greylev',0.2,'backgnd',[1,1,1]);
show_slices(imr);

