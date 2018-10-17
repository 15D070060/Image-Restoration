function varargout = untitled(varargin)
% UNTITLED MATLAB code for untitled.fig
%      UNTITLED, by itself, creates a new UNTITLED or raises the existing
%      singleton*.
%
%      H = UNTITLED returns the handle to a new UNTITLED or the handle to
%      the existing singleton*.
%
%      UNTITLED('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UNTITLED.M with the given input arguments.
%
%      UNTITLED('Property','Value',...) creates a new UNTITLED or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before untitled_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to untitled_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help untitled

% Last Modified by GUIDE v2.5 17-Oct-2018 13:43:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @untitled_OpeningFcn, ...
                   'gui_OutputFcn',  @untitled_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before untitled is made visible.
function untitled_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to untitled (see VARARGIN)

% Choose default command line output for untitled
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes untitled wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = untitled_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------LOAD GROUND TRUTH IMAGE----------------------------------------

% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
% hObject    handle to Load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end
im=imread(path);

axes(handles.axes1);
imshow(im);

%-------------------------------------------------------LOAD KERNEL---------------------------------------------------

% --- Executes on button press in Load_Kernel.
function Load_Kernel_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Kernel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imkernel 
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error');
    return
end
imkernel=imread(path);


axes(handles.axes3);
imshow(imkernel);

%-------------------------------------------------------SAVE IMAGE------------------------------------------------------

% --- Executes on button press in Save.
function Save_Callback(hObject, eventdata, handles)
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imdeblur
[filename, foldername] = uiputfile('output.png');
complete_name = fullfile(foldername, filename);
imwrite(imdeblur,complete_name);


%-------------------------------------------------------BLUR IMAGE----------------------------------------------------

% --- Executes on button press in Blur.
function Blur_Callback(hObject, eventdata, handles)
% hObject    handle to Blur (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im imblur rimblur gimblur bimblur imkernel rpadimblur gpadimblur bpadimblur padimkernel rimblurfft  gimblurfft bimblurfft imkernelfft rimdeblurfft gimdeblurfft bimdeblurfft rimdeblur gimdeblur bimdeblur runpadimdeblur gunpadimdeblur bunpadimdeblur imdeblur  

imblur = im;

rimblur = imblur(:,:,1);
gimblur = imblur(:,:,2);
bimblur = imblur(:,:,3);

[rb,cb] = size(rimblur);
[rk,ck] = size(imkernel);

rpadimblur = zeros(rb+rk-1,cb+ck-1);
gpadimblur = zeros(rb+rk-1,cb+ck-1);
bpadimblur = zeros(rb+rk-1,cb+ck-1);
padimkernel = zeros(rb+rk-1,cb+ck-1);

rpadimblur(1:rb,1:cb)= rimblur;
gpadimblur(1:rb,1:cb)= gimblur;
bpadimblur(1:rb,1:cb)= bimblur;
padimkernel(1:rk,1:ck)= imkernel;

rimblurfft = fftshift(fft2(rpadimblur));
gimblurfft = fftshift(fft2(gpadimblur));
bimblurfft = fftshift(fft2(bpadimblur));
imkernelfft = fftshift(fft2(padimkernel));



rimdeblurfft = rimblurfft .* imkernelfft ;
gimdeblurfft = gimblurfft .* imkernelfft ;
bimdeblurfft = bimblurfft .* imkernelfft ;


rimdeblur = ifft2(ifftshift(rimdeblurfft));
gimdeblur = ifft2(ifftshift(gimdeblurfft));
bimdeblur = ifft2(ifftshift(bimdeblurfft));


runpadimdeblur = zeros(rb,cb);
runpadimdeblur = rimdeblur(1:rb,1:cb);

gunpadimdeblur = zeros(rb,cb);
gunpadimdeblur = gimdeblur(1:rb,1:cb);


bunpadimdeblur = zeros(rb,cb);
bunpadimdeblur = bimdeblur(1:rb,1:cb);

imdeblur = zeros(rb,cb,3);

imdeblur(:,:,1) = runpadimdeblur; 
imdeblur(:,:,2) = gunpadimdeblur; 
imdeblur(:,:,3) = bunpadimdeblur; 

imdeblur=real(imdeblur);
imdeblur=abs((255/max(imdeblur(:))).*imdeblur);

imblur = imdeblur;

axes(handles.axes2);
imshow(uint8(imblur));

%-------------------------------------------------------DEBLUR INVERSE FILTER-----------------------------------------

% --- Executes on button press in Inverse.
function Inverse_Callback(hObject, eventdata, handles)
% hObject    handle to Inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global imblur rimblur gimblur bimblur imkernel rpadimblur gpadimblur bpadimblur padimkernel rimblurfft  gimblurfft bimblurfft imkernelfft rimdeblurfft gimdeblurfft bimdeblurfft rimdeblur gimdeblur bimdeblur runpadimdeblur gunpadimdeblur bunpadimdeblur imdeblur  

rimblur = imblur(:,:,1);
gimblur = imblur(:,:,2);
bimblur = imblur(:,:,3);

[rb,cb] = size(rimblur);
[rk,ck] = size(imkernel);

rpadimblur = zeros(rb+rk-1,cb+ck-1);
gpadimblur = zeros(rb+rk-1,cb+ck-1);
bpadimblur = zeros(rb+rk-1,cb+ck-1);
padimkernel = zeros(rb+rk-1,cb+ck-1);

rpadimblur(1:rb,1:cb)= rimblur;
gpadimblur(1:rb,1:cb)= gimblur;
bpadimblur(1:rb,1:cb)= bimblur;

padimkernel(1:rk,1:ck)= imkernel;

rimblurfft = fftshift(fft2(rpadimblur));
gimblurfft = fftshift(fft2(gpadimblur));
bimblurfft = fftshift(fft2(bpadimblur));
imkernelfft = fftshift(fft2(padimkernel));

k= 1500;
imkernelfft(abs(imkernelfft)<k) = k;

rimdeblurfft = rimblurfft ./ imkernelfft ;
gimdeblurfft = gimblurfft ./ imkernelfft ;
bimdeblurfft = bimblurfft ./ imkernelfft ;


rimdeblur = ifft2(ifftshift(rimdeblurfft));
gimdeblur = ifft2(ifftshift(gimdeblurfft));
bimdeblur = ifft2(ifftshift(bimdeblurfft));


runpadimdeblur = zeros(rb,cb);
runpadimdeblur = rimdeblur(1:rb,1:cb);

gunpadimdeblur = zeros(rb,cb);
gunpadimdeblur = gimdeblur(1:rb,1:cb);


bunpadimdeblur = zeros(rb,cb);
bunpadimdeblur = bimdeblur(1:rb,1:cb);

imdeblur = zeros(rb,cb,3);

imdeblur(:,:,1) = runpadimdeblur; 
imdeblur(:,:,2) = gunpadimdeblur; 
imdeblur(:,:,3) = bunpadimdeblur; 

imdeblur=real(imdeblur);
imdeblur=abs((255/max(imdeblur(:))).*imdeblur)*1.25;


axes(handles.axes2);
imshow(uint8(imdeblur));

%-------------------------------------------------------DEBLUR TRUNCATED INVERSE FILTER-------------------------------

% --- Executes on slider movement.
function Truncated_inverse_Callback(hObject, eventdata, handles)
% hObject    handle to Truncated_inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global trimkernelfft imblur rimblur gimblur bimblur imkernel rpadimblur gpadimblur bpadimblur padimkernel rimblurfft  gimblurfft bimblurfft imkernelfft rimdeblurfft gimdeblurfft bimdeblurfft rimdeblur gimdeblur bimdeblur runpadimdeblur gunpadimdeblur bunpadimdeblur imdeblur  

rimblur = imblur(:,:,1);
gimblur = imblur(:,:,2);
bimblur = imblur(:,:,3);

[rb,cb] = size(rimblur);
[rk,ck] = size(imkernel);

rpadimblur = zeros(rb+rk-1,cb+ck-1);
gpadimblur = zeros(rb+rk-1,cb+ck-1);
bpadimblur = zeros(rb+rk-1,cb+ck-1);
padimkernel = zeros(rb+rk-1,cb+ck-1);

rpadimblur(1:rb,1:cb)= rimblur;
gpadimblur(1:rb,1:cb)= gimblur;
bpadimblur(1:rb,1:cb)= bimblur;

padimkernel(1:rk,1:ck)= imkernel;

rimblurfft = fftshift(fft2(rpadimblur));
gimblurfft = fftshift(fft2(gpadimblur));
bimblurfft = fftshift(fft2(bpadimblur));
imkernelfft = fftshift(fft2(padimkernel));



r= rb+rk-1 ;
c= cb+ck-1 ;
s = (400* get(hObject,'Value'));

trimkernelfft = ones(r,c);
trimkernelfft( ((r-s)/2)+1 : (r+s)/2 , ((c-s)/2)+1 : (c+s)/2 ) = imkernelfft( ((r-s)/2)+1 : (r+s)/2 , ((c-s)/2)+1 : (c+s)/2 ) ;

k= 1500;
trimkernelfft(abs(trimkernelfft)<k) = k;


rimdeblurfft = rimblurfft ./ trimkernelfft ;
gimdeblurfft = gimblurfft ./ trimkernelfft ;
bimdeblurfft = bimblurfft ./ trimkernelfft ;


rimdeblur = ifft2(ifftshift(rimdeblurfft));
gimdeblur = ifft2(ifftshift(gimdeblurfft));
bimdeblur = ifft2(ifftshift(bimdeblurfft));


runpadimdeblur = zeros(rb,cb);
runpadimdeblur = rimdeblur(1:rb,1:cb);

gunpadimdeblur = zeros(rb,cb);
gunpadimdeblur = gimdeblur(1:rb,1:cb);


bunpadimdeblur = zeros(rb,cb);
bunpadimdeblur = bimdeblur(1:rb,1:cb);

imdeblur = zeros(rb,cb,3);

imdeblur(:,:,1) = runpadimdeblur; 
imdeblur(:,:,2) = gunpadimdeblur; 
imdeblur(:,:,3) = bunpadimdeblur; 

imdeblur=real(imdeblur);
imdeblur=abs((255/max(imdeblur(:))).*imdeblur)*1.05;


axes(handles.axes2);
imshow(uint8(imdeblur));

img=imdeblur;
img=double(img(:));
ima=max(img(:));
imi=min(img(:));
mse=std(img(:));
psnrti = 20*log10(((ima*2)/mse));
 textLabel = num2str(psnrti) ;
 set(handles.edit4 , 'String', textLabel);
 
[v,m] = ssim(imdeblur,imblur);
textLabel = num2str(v) ;
set(handles.edit5 , 'String', textLabel);


% --- Executes during object creation, after setting all properties.
function Truncated_inverse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Truncated_inverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Min',0);
set(hObject,'Max',1);


%-------------------------------------------------------DEBLUR USING WEINER FILTER-------------------------------


% --- Executes on slider movement.
function Weiner__Callback(hObject, eventdata, handles)
 
% hObject    handle to Weiner_ (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global img imblur rimblur gimblur bimblur imkernel rpadimblur gpadimblur bpadimblur padimkernel rimblurfft  gimblurfft bimblurfft imkernelfft rimdeblurfft gimdeblurfft bimdeblurfft rimdeblur gimdeblur bimdeblur runpadimdeblur gunpadimdeblur bunpadimdeblur imdeblur  


rimblur = imblur(:,:,1);
gimblur = imblur(:,:,2);
bimblur = imblur(:,:,3);

img=imblur;
img=double(img(:));
ima=max(img(:));
imi=min(img(:));
mse=std(img(:));
k = 1/(20*log10((ima-imi)./mse));
k1= 10*k*get(hObject,'Value');

[rb,cb] = size(rimblur);
[rk,ck] = size(imkernel);

rpadimblur = zeros(rb+rk-1,cb+ck-1);
gpadimblur = zeros(rb+rk-1,cb+ck-1);
bpadimblur = zeros(rb+rk-1,cb+ck-1);
padimkernel = zeros(rb+rk-1,cb+ck-1);

rpadimblur(1:rb,1:cb)= rimblur;
gpadimblur(1:rb,1:cb)= gimblur;
bpadimblur(1:rb,1:cb)= bimblur;
padimkernel(1:rk,1:ck)= imkernel;

rimblurfft = fftshift(fft2(rpadimblur));
gimblurfft = fftshift(fft2(gpadimblur));
bimblurfft = fftshift(fft2(bpadimblur));
imkernelfft = fftshift(fft2(padimkernel));

l= 1500;
imkernelfft(abs(imkernelfft)<l) = l;



rimdeblurfft = rimblurfft .* (conj(imkernelfft)/ (norm(imkernelfft)^2 + k ));
gimdeblurfft = gimblurfft .* (conj(imkernelfft)/ (norm(imkernelfft)^2 + k ));
bimdeblurfft = bimblurfft .* (conj(imkernelfft)/ (norm(imkernelfft)^2 + k ));


rimdeblur = ifft2(ifftshift(rimdeblurfft));
gimdeblur = ifft2(ifftshift(gimdeblurfft));
bimdeblur = ifft2(ifftshift(bimdeblurfft));


runpadimdeblur = zeros(rb,cb);
runpadimdeblur = rimdeblur(1:rb,1:cb);

gunpadimdeblur = zeros(rb,cb);
gunpadimdeblur = gimdeblur(1:rb,1:cb);

bunpadimdeblur = zeros(rb,cb);
bunpadimdeblur = bimdeblur(1:rb,1:cb);

imdeblur = zeros(rb,cb,3);

imdeblur(:,:,1) = runpadimdeblur; 
imdeblur(:,:,2) = gunpadimdeblur; 
imdeblur(:,:,3) = bunpadimdeblur; 

imdeblur=real(imdeblur);
imdeblur=abs((255/max(imdeblur(:))).*imdeblur);


axes(handles.axes2);
imshow(uint8(imdeblur));

img=imdeblur;
img=double(img(:));
ima=max(img(:));
imi=min(img(:));
mse=std(img(:));
psnrw = 20*log10(((ima*2)/ mse));
textLabel = num2str(psnrw) ;
set(handles.edit2 , 'String', textLabel);

[v,m] = ssim(imdeblur,imblur);
textLabel = num2str(v) ;
set(handles.edit3 , 'String', textLabel);


% --- Executes during object creation, after setting all properties.
function Weiner__CreateFcn(hObject, eventdata, handles)
% hObject    handle to Weiner_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'Min',-1);
set(hObject,'Max',1);
%-------------------------------------------------------DEBLUR USING CLS FILTER--------------------------------------


% --- Executes on slider movement.
function CLS__Callback(hObject, eventdata, handles)
% hObject    handle to CLS_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global img imblur rimblur gimblur bimblur imkernel rpadimblur gpadimblur bpadimblur padimkernel rimblurfft  gimblurfft bimblurfft imkernelfft rimdeblurfft gimdeblurfft bimdeblurfft rimdeblur gimdeblur bimdeblur runpadimdeblur gunpadimdeblur bunpadimdeblur imdeblur  


rimblur = imblur(:,:,1);
gimblur = imblur(:,:,2);
bimblur = imblur(:,:,3);

C = [0,-1,0 ; -1,4,-1 ; 0,-1,0];
g= 2*10*get(hObject,'Value');

[rb,cb] = size(rimblur);
[rk,ck] = size(imkernel);

rpadimblur = zeros(rb+rk-1,cb+ck-1);
gpadimblur = zeros(rb+rk-1,cb+ck-1);
bpadimblur = zeros(rb+rk-1,cb+ck-1);
padimkernel = zeros(rb+rk-1,cb+ck-1);

rpadimblur(1:rb,1:cb)= rimblur;
gpadimblur(1:rb,1:cb)= gimblur;
bpadimblur(1:rb,1:cb)= bimblur;
padimkernel(1:rk,1:ck)= imkernel;

rimblurfft = fftshift(fft2(rpadimblur));
gimblurfft = fftshift(fft2(gpadimblur));
bimblurfft = fftshift(fft2(bpadimblur));
imkernelfft = fftshift(fft2(padimkernel));

l= 1500;
imkernelfft(abs(imkernelfft)<l) = l;

rimdeblurfft = rimblurfft ./ (conj(imkernelfft)/ (norm(imkernelfft) + g*norm(C)));
gimdeblurfft = gimblurfft ./ (conj(imkernelfft)/ (norm(imkernelfft) + g*norm(C)));
bimdeblurfft = bimblurfft ./(conj(imkernelfft)/ (norm(imkernelfft) + g*norm(C)));


rimdeblur = ifft2(ifftshift(rimdeblurfft));
gimdeblur = ifft2(ifftshift(gimdeblurfft));
bimdeblur = ifft2(ifftshift(bimdeblurfft));


runpadimdeblur = zeros(rb,cb);
runpadimdeblur = rimdeblur(1:rb,1:cb);

gunpadimdeblur = zeros(rb,cb);
gunpadimdeblur = gimdeblur(1:rb,1:cb);


bunpadimdeblur = zeros(rb,cb);
bunpadimdeblur = bimdeblur(1:rb,1:cb);

imdeblur = zeros(rb,cb,3);

imdeblur(:,:,1) = runpadimdeblur; 
imdeblur(:,:,2) = gunpadimdeblur; 
imdeblur(:,:,3) = bunpadimdeblur; 

imdeblur=real(imdeblur);

imdeblur=abs((255/max(imdeblur(:))).*imdeblur)*1.15;

axes(handles.axes2);
imshow(uint8(imdeblur));

img=imdeblur;
img=double(img(:));
ima=max(img(:));
imi=min(img(:));
mse=std(img(:));
psnrc = 20*log10(((ima*2)/ mse));
textLabel = num2str(psnrc) ;
set(handles.edit6 , 'String', textLabel);

[v,m] = ssim(imdeblur,imblur);
textLabel = num2str(v) ;
set(handles.edit7 , 'String', textLabel);


% --- Executes during object creation, after setting all properties.
function CLS__CreateFcn(hObject, eventdata, handles)
% hObject    handle to CLS_ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

set(hObject,'Min',-1);
set(hObject,'Max',1);


%---------------------------------------------------------text boxes for psnr ans ssim--------------------------------------------------


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
%        str2double(get(hObject,'String')) returns contents of edit3 as a double

function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO) eventdata  reserved - to be defined
% in a future version of MATLAB handles    empty - handles not created
% until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
