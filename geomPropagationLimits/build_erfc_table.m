dt = 1e-4;
max = 15;

t = 0:dt:max+dt;
y = erfc(t);

file_h = fopen(['erfc_table.dat'], 'w');
fprintf(file_h, '%15.15e\n', y)
fclose(file_h)