if exist('last','var');
    temp_ = cd;
    cd(last);    
    last = temp_;
    clear temp_;
end