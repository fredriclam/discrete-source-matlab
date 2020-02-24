function varargout = window(varargin)
% WINDOW MATLAB code for window.fig
%      WINDOW, by itself, creates a new WINDOW or raises the existing
%      singleton*.
%
%      H = WINDOW returns the handle to a new WINDOW or the handle to
%      the existing singleton*.
%
%      WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WINDOW.M with the given input arguments.
%
%      WINDOW('Property','Value',...) creates a new WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help window

% Last Modified by GUIDE v2.5 13-Apr-2017 15:57:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @window_OpeningFcn, ...
                   'gui_OutputFcn',  @window_OutputFcn, ...
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
    
% --- Executes just before window is made visible.
function window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to window (see VARARGIN)

% Choose default command line output for window
handles.output = hObject;
% Simulation flag off
handles.simulationOn = false;
handles.ylim = [-0.1, 1.5];
handles.xlim = [-0.5, 10.5];
handles.dtDefault = 0.03;
% handles.dt = handles.dtDefault;
% handles.T_ign = 0.55;

% Performance-affecting parameters
handles.xres = 250;
handles.realUpdateTime = 0.01;
handles.numParticles = 75;

% Save data to handles
guidata(hObject, handles);

% Initialize data
handles = initData(hObject, eventdata, handles);
plot(handles.x,handles.y);
ylim(handles.ylim);
xlim(handles.xlim);
% Choose axis
axes(handles.axes1);
cla;

% % This sets up the initial plot - only do when we are invisible
% % so window can get raised using window.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end

% UIWAIT makes window wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.slider1.Value = 0.5;
handles.slider2.Value = 0.2;
handles.slider3.Value = 0;
updateModelParameters(hObject, eventdata, handles);

function handles = initData(hObject, eventdata, handles)
handles.x = linspace(handles.xlim(1),handles.xlim(2),handles.xres);
handles.y = zeros(size(handles.x));
handles.t = 0;
% Construct particles
for i = 1:handles.numParticles
    particles(i) = struct('x',i-handles.numParticles+10, ...
        'ignited', false,...
        't0', 0, ...
        'localTemp', 0);
end
handles.particles = particles;
% Save data
guidata(hObject, handles);

% Updates temperature field vector y at vector x
function handles = updateField(hObject, eventdata, handles)
% Initialize to zero
handles.y = zeros(size(handles.y));
% Superposition of sources
for i = 1:length(handles.particles)
    handles.y = handles.y + ...
        responseFunction(handles, handles.particles(i), handles.x, handles.t);
end

% Calculate local temperatures
for i = 1:length(handles.particles)
    % Evaluate temperature at the particle (grid-free)
    y_particle = 0;
    for j = 1:length(handles.particles)
        y_particle = y_particle + ...
            responseFunction(handles, ...
            handles.particles(j), ...
            handles.particles(i).x, ...
            handles.t);        
    end
    handles.particles(i).localTemp = y_particle;
    % Check ignition
    if ~handles.particles(i).ignited && y_particle >= handles.T_ign
        handles.particles(i).ignited = true;
        handles.particles(i).t0 = handles.t;
    end
end
guidata(hObject, handles);

% Returns temperature response of the field due to particle
function y = responseFunction(handles, particle, x, t)
% Load variables
x0 = particle.x;
t0 = particle.t0;
tauc = handles.tauc;
% Non-ignited particle, or too soon after ignition (singularity)
if ~particle.ignited || t - particle.t0 < 0.01
    y = 0;
    return;
end
% Compute response
if tauc == 0
    y = 1./sqrt(4*pi*(t-t0)) .* ...
        exp( - (x-x0).^2 ./ (4*(t-t0)) );
else
    r = abs(x-x0);
%     y = sqrt((t-t0)/pi) .* exp(-(x-x0).^2 ./ (4*(t-t0))) - ...
%         (x-x0)/2 .* erfc((x-x0)./(2*sqrt(t-t0)));
%     if t > t0 + tauc + 0.01
%         y = y - ...
%             (sqrt((t-t0-tauc)/pi) .* exp(-(x-x0).^2 ./ (4*(t-t0-tauc)))-...
%             (x-x0)/2 .* erfc((x-x0)./(2*sqrt(t-t0-tauc))));
%     end

    y = sqrt((t-t0)/pi) .* exp(-r.^2 ./ (4*(t-t0))) - ...
        r/2 .* erfc(r./(2*sqrt(t-t0)));
    if t > t0 + tauc + 0.01
        y = y - ...
            (sqrt((t-t0-tauc)/pi) .* exp(-r.^2 ./ (4*(t-t0-tauc)))-...
            r/2 .* erfc(r./(2*sqrt(t-t0-tauc))));
    end


    y = y / tauc;
end


function handles = tryIgnite(hObject, eventdata, handles, particlePosition)
% Identify the position
if ~handles.particles(handles.numParticles - 10 + particlePosition).ignited
    handles.particles(handles.numParticles - 10 + particlePosition).ignited = true;
    handles.particles(handles.numParticles - 10 + particlePosition).t0 = handles.t;
end
guidata(hObject, handles);

function handles = shiftParticles(hObject, eventdata, handles)
% Copy back particles
for i = 1:handles.numParticles-11
    handles.particles(i) = struct('x', handles.particles(i).x, ...
        'ignited', handles.particles(i+10).ignited, ...
        't0', handles.particles(i+10).t0, ...
        'localTemp', 0);
end
% New particles
for i = handles.numParticles-10:handles.numParticles
    handles.particles(i) = struct('x',handles.particles(i).x, ...
        'ignited', false,...
        't0', 0, ...
        'localTemp', 0);
end
guidata(hObject, handles);

function handles = updateModelParameters(hObject, eventdata, handles)
% Get parameters from sliders
handles.speedModifier = handles.slider1.Value;
handles.T_ign = handles.slider2.Value;
handles.taucModifier = handles.slider3.Value;
% Compute dt, tauc based on modifiers
% handles.dt =  handles.dtDefault * handles.speedModifier;
handles.dt = handles.dtDefault * 10.^(-1.5+3.5*handles.speedModifier);
if handles.taucModifier == 0
    handles.tauc = 0;
else
    handles.tauc = 10.^(-2+4*handles.taucModifier);
end

% Save data
guidata(hObject, handles);
% Update text display
handles.text4.String = num2str(handles.dt,'%.4f');
handles.text5.String = num2str(handles.T_ign,'%.4f');
handles.text6.String = num2str(handles.tauc,'%.4f');

% --- Outputs from this function are returned to the command line.
function varargout = window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Switch simulation on or off
handles.simulationOn = ~handles.simulationOn;
guidata(hObject,handles);

% Choose axis
axes(handles.axes1);
cla;
while handles.simulationOn
    % Catch exceptions if hObject is destroyed
    try
        % Grab data
        handles = guidata(hObject);
        % Update time
        handles.t = handles.t + handles.dt;
        % Save data
        guidata(hObject, handles);
        
        % If ignition reaches last particle, shift backward
        if handles.particles(handles.numParticles).ignited
            handles = shiftParticles(hObject, eventdata, handles);
        end
        
        % Update data
        handles = updateField(hObject, eventdata, handles);
        
%         disp(sum([handles.particles.ignited]));
%         disp(handles.t);
        
        % Plot data
        plot(handles.x,handles.y);
        hold on
        % Reference line
        x = [handles.particles.x];
        ignited = [handles.particles.ignited];
        localTemp = [handles.particles.localTemp];
        plot(handles.x, handles.T_ign*ones(size(handles.x)), ':');
        % Particles (note: upon reaching ignition, the sources dump heat
        % into the medium, and this heat affects the temperature at the
        % source--but this doesn't matter, because ignition temperature
        % kinetics implies the source has already gone off and releases
        % heat independent of temperature)
        plot(x(find(ignited)), localTemp(find(ignited)), ...
            'or');
        plot(x(find(~ignited)), localTemp(find(~ignited)), ...
            'ob');
        hold off
        xlim(handles.xlim);
        ylim(handles.ylim);
        pause(handles.realUpdateTime);
    catch ME
        if strcmp(ME.identifier, 'MATLAB:guidata:InvalidInput')
            break
        else
            rethrow(ME)
        end
    end
end

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

handles.simulationOn = false;
guidata(hObject,handles);

delete(handles.figure1)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 1);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 2);

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 3);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 4);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 5);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 6);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 7);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 8);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 9);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 10);

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% handles.speedModifier = get(hObject, 'value');
% guidata(hObject, handles);
updateModelParameters(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
% Simulation speed parameter
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
handles.speedModifier = get(hObject, 'value');
handles.slider1.Value = 0.5;
guidata(hObject, handles);

% --- Executes on button press in pushbutton12. RESET button
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
initData(hObject, eventdata, handles);

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% handles.T_ign = get(hObject, 'value');
% guidata(hObject, handles);
updateModelParameters(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
% Tign
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
handles.T_ign = get(hObject, 'value');
handles.slider2.Value = 0.2;
guidata(hObject, handles);


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
% handles.taucModifier = get(hObject, 'value');
% guidata(hObject, handles);
updateModelParameters(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
% Tauc slider
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tryIgnite(hObject, eventdata, handles, 11);
