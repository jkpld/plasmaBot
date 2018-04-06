%% Load data
pth = 'K:\Notre_Dame\RadLab\plasmaBot\';
% file = 'PSF_smallTest_20170718_170546.h5';
% file = 'PSF_smallTest2_20170718_170546.h5';
% file = 'PSF_smallTest3_20170718_181049.h5';
% file = 'PSF_20170718_191931.h5';
% file = 'PSF_20170719_232345.h5';
% file = 'HeAir_test750ms_20170719_215345.h5';
file = 'HeAir_testFineY_20170720_162310.h5';
% file_name = 'K:\Google_Drive\NotreDame\RadiationLab\plasmaBot\PSF_20170716_211333.h5';
file_name = [pth, file];
file_name = 'K:\Notre_Dame\RadLab\spec2\PSF_20171107_133023.h5';
%%

dat2.Spec = h5read(file_name,'/data');
dat2.X = h5readatt(file_name,'/data','X');
dat2.Y = 145-h5readatt(file_name,'/data','Y');
dat2.Z = h5readatt(file_name,'/data','Z');
dat2.Wavelength = h5readatt(file_name,'/data','Wavelengths');

bc = {double(dat2.X), double(dat2.Y), double(dat2.Z)};

%% Compute brightness

dat2.B = squeeze(mean(dat2.Spec,1)-mean(dat2.Spec(dat2.Wavelength>830,:,:,:),1));
% dat2.B = flip(dat2.B,1);
% dat2.B = dat2.B-min(dat2.B(:));
% dat2.B = dat2.B/max(dat2.B(:));

%%
[X,Z] = meshgrid(double(dat2.X),double(dat2.Z));
try close(fig1), catch, end;
fig1 = figure;

for i = 1:numel(dat2.Y)
    surface(X,double(dat2.Y(i))*ones(size(X)), Z, squeeze(dat2.B(:,i,:)), 'FaceAlpha',0.5)
end

shading interp
grid on
daspect([1 1 1])

%%
[X,Y] = meshgrid(double(dat2.X),double(dat2.Y));
try close(fig2), catch, end;
fig2 = figure;

for i = 1:numel(dat2.Z)
    surface(X,Y, double(dat2.Z(i))*ones(size(X)), squeeze(dat2.B(:,:,i))', 'FaceAlpha',0.5)
end

shading interp
grid on
daspect([1 1 1])

%%

try close(fig3), catch, end;
fig3 = figure;

subplot(3,1,1)
tmp = squeeze(sum(dat2.B,1));
tmp = tmp-min(tmp(:));
tmp = tmp/max(tmp(:));
for i = 1:numel(dat2.Y)
    line(bc{1}, dat2.Y(i)*ones(size(bc{1})), tmp(i,:))
end
view(0,0)
title('X (y slices)')

subplot(3,1,2)
tmp = squeeze(sum(dat2.B,3));
tmp = tmp-min(tmp(:));
tmp = tmp/max(tmp(:));
for i = 1:numel(dat2.Y)
    line(bc{3}, dat2.Y(i)*ones(size(bc{3})), tmp(:,i))
end
view(0,0)
title('Z (y slices)')

subplot(3,1,3)

opLine = squeeze(sum(sum(dat2.B,3)));
opLine = opLine - min(opLine);
opLine = opLine/max(opLine);
line(bc{2}, opLine)
title('along optical axis')

%%
try close(fig4), catch, end
fig4 = figure;
rage = 1;
tmp = squeeze(sum(dat2.B(:,:,rage),3));
tmp = tmp-min(tmp(:));
tmp = tmp/max(tmp(:));
contourf(bc{2},bc{1},tmp);
daspect([1 1 1])

%%
isosurfaceProjectionPlot(dat2.B,[1,2,3],[1000,1500,2000],'Bin_Centers',bc,'Tick_Spacing',[1,1,1],'ColorScale',@(x) sqrt(x))
daspect(size(dat2.B)./cellfun(@(x) range(x), bc))
set(gca,'Zdir','reverse')