module unload python
module load python/anaconda3/2018.12
make html
rsync -a --delete _build/html/ ursa:public_html/dispatch/
