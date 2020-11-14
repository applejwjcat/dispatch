module amr_parameters

  ! Define real types
  integer,parameter::sp=kind(1.0E0)
#ifndef NPRE
  integer,parameter::dp=kind(1.0E0) ! default
#else
#if NPRE==4
  integer,parameter::dp=kind(1.0E0) ! real*4
#else
  integer,parameter::dp=kind(1.0D0) ! real*8
#endif
#endif
#ifdef QUADHILBERT
  integer,parameter::qdp=kind(1.0_16) ! real*16
#else
  integer,parameter::qdp=kind(1.0_8) ! real*8
#endif
  integer,parameter::MAXOUT=100
  integer,parameter::MAXLEVEL=100
  integer,parameter::mid=120
  
  ! Number of dimensions
#ifndef NDIM
  integer,parameter::ndim=1
#else
  integer,parameter::ndim=NDIM
#endif
  integer,parameter::twotondim=2**ndim
  integer,parameter::threetondim=3**ndim
  integer,parameter::twondim=2*ndim

  ! Vectorization parameter
#ifndef NVECTOR
  integer,parameter::nvector=500  ! Size of vector sweeps
#else
  integer,parameter::nvector=NVECTOR
#endif

  integer, parameter :: nstride = 65536

  ! Run control
  logical::hydro   =.false.   ! Hydro activated
  logical::pic     =.false.   ! Particle In Cell activated
  logical::poisson =.false.   ! Poisson solver activated
  logical::cosmo   =.false.   ! Cosmology activated
  logical::star    =.false.   ! Star formation activated
  logical::sink    =.false.   ! Sink particles activated
  logical::debug   =.false.   ! Debug mode activated
  logical::static  =.false.   ! Static mode activated
  logical::tracer  =.false.   ! Tracer particles activated
  logical::lightcone=.false.  ! Enable lightcone generation
  logical::clumpfind=.false.  ! Enable clump finder
  logical::aton=.false.       ! Enable ATON coarse grid radiation transfer
  logical::do_benchmark=.false. ! Disable IO for benchmarking runs
  logical::do_particle_dump=.false. ! Start run and immedeately dump particles snapshot
  logical::swap_domains=.false. ! If overload>1 swap domain to optimize load
  logical::chemistry=.false.  ! Is RAMSES coupled with an external chemistry solver ? (e.g. KROME)

  ! Mesh parameters
  integer::evenout=0          ! Even out load on all levels (1)
  integer::geom=1             ! 1: cartesian, 2: cylindrical, 3: spherical
  integer::nx=1,ny=1,nz=1     ! Number of coarse cells in each dimension
  integer::levelmin=1         ! Full refinement up to levelmin
  integer::nlevelmax=1        ! Maximum number of level
  integer::ngridmax=0         ! Maximum number of grids
  integer,dimension(1:MAXLEVEL)::nexpand=1 ! Number of mesh expansion
  integer::nexpand_bound=1    ! Number of mesh expansion for virtual boundaries
  real(dp)::boxlen=1.0D0      ! Box length along x direction
  character(len=128)::ordering='hilbert'
  logical::cost_weighting=.true. ! Activate load balancing according to cpu time
  integer::load_weighting=0   ! 0: subcycle product, 1: max grids, 2: level time
  ! Recursive bisection tree parameters
  integer::nbilevelmax=1      ! Max steps of bisection partitioning
  integer::nbinodes=3         ! Max number of internal nodes
  integer::nbileafnodes=2     ! Max number of leaf (terminal) nodes
  real(dp)::bisec_tol=0.05d0  ! Tolerance for bisection load balancing
  logical::subcycle_extrap=.false.
  integer::a_verbose=0

  ! Step parameters
  integer::nudge_bound_keys=0 ! Legacy load_balance
  integer::nrestart=0         ! New run or backup file number
  integer::nstepmax=1000000   ! Maximum number of time steps
  integer::ncontrol=1         ! Write control variables
  integer::fbackup=1000000    ! Backup data to disk
  integer::nremap=0           ! Load balancing frequency (0: never)
  integer::real_size=0        ! input/output real size
  real(kind=dp)::fremap=0.0   ! fractional unbalance that triggers load balance
  real,dimension(MAXLEVEL)::level_load=1.0 ! relative load for each level

  ! Output parameters
  integer::iout=0             ! Increment for output times
  integer::ifout=1            ! Increment for output files
  integer::iback=1            ! Increment for backup files
  integer::noutput=1          ! Total number of outputs
  integer::foutput=1000000    ! Frequency of outputs
  integer::fscratch=1000000   ! Frequency of scratch outputs
  integer::output_mode=0      ! Output mode (for hires runs)
  integer::trace_level=0      ! controls output from trace_mpi() calls
  character(len=80)::datadir='.' ! data directory for output
  integer::timer_type=0       ! type of timer measurement
  integer::debug_level=0      ! debug verbosity

  ! Lightcone parameters
  real(dp)::thetay_cone=12.5
  real(dp)::thetaz_cone=12.5
  real(dp)::zmax_cone=2.0

  ! Cosmology and physical parameters
  real(dp)::boxlen_ini        ! Box size in h-1 Mpc
  real(dp)::omega_b=0.0D0     ! Omega Baryon
  real(dp)::omega_m=1.0D0     ! Omega Matter
  real(dp)::omega_l=0.0D0     ! Omega Lambda
  real(dp)::omega_k=0.0D0     ! Omega Curvature
  real(dp)::h0     =1.0D0     ! Hubble constant in km/s/Mpc
  real(dp)::aexp   =1.0D0     ! Current expansion factor
  real(dp)::hexp   =0.0D0     ! Current Hubble parameter
  real(dp)::n_sink =1D30     ! Sink particle density threshold in H/cc
  real(dp)::m_star =-1.0      ! Star particle mass in units of mass_sph
  real(dp)::n_star =0.1D0     ! Star formation density threshold in H/cc
  real(dp)::t_star =0.0D0     ! Star formation time scale in Gyr
  real(dp)::eps_star=0.0D0    ! Star formation efficiency (0.02 at n_star=0.1 gives t_star=8 Gyr)
  real(dp)::jeans_ncells=-1   ! Jeans polytropic EOS
  real(dp)::T2_star=0.0D0     ! Typical ISM polytropic temperature
  real(dp)::g_star =1.6D0     ! Typical ISM polytropic index
  real(dp)::baro_exp=2.0D0    ! Barotropic exponent
  real(dp)::baro_c=4.0D0      ! Barotropic coefficient
  real(dp)::del_star=2.D2     ! Minimum overdensity to define ISM
  real(dp)::eta_sn =0.0D0     ! Supernova mass fraction
  real(dp)::yield  =0.0D0     ! Supernova yield
  real(dp)::f_ek   =1.0D0     ! Supernovae kinetic energy fraction (only between 0 and 1)
  real(dp)::rbubble=0.0D0     ! Supernovae superbubble radius in pc
  real(dp)::f_w    =0.0D0     ! Supernovae mass loading factor
  integer ::ndebris=1         ! Supernovae debris particle number
  real(dp)::mass_gmc=-1.0     ! Stochastic exploding GMC mass
  real(dp)::z_ave  =0.0D0     ! Average metal abundance
  real(dp)::B_ave  =0.0D0     ! Average magnetic field
  real(dp)::z_reion=8.5D0     ! Reionization redshift
  real(dp)::T2_start          ! Starting gas temperature
  real(dp)::t_delay=1.0D1     ! Feedback time delay in Myr
  real(dp)::J21    =0.0D0     ! UV flux at threshold in 10^21 units
  real(dp)::a_spec =1.0D0     ! Slope of the UV spectrum
  real(dp)::beta_fix=0.0D0    ! Pressure fix parameter
  real(dp)::rsink_max=10      ! Sink isolation criterion in kpc
  real(dp)::msink_max=1d5     ! Maximum seed mass in solar masses
  real(dp)::entropy_elimit=1. ! ratio below which entropy_fix is active
  integer ::n_entropy(2)=0    ! number of test
  logical ::self_shielding=.false.
  logical ::pressure_fix=.false.
  logical ::entropy_fix=.false.
  real(dp)::temp_iso = 1.0_dp ! Temperature in case of isothermal
  logical ::nordlund_fix=.true.
  logical ::cooling=.false.
  logical ::metal=.false.
  logical ::bondi=.true.      ! Activate Bondi accretion onto sink particle 
  logical ::haardt_madau=.false.
  logical ::delayed_cooling=.false.
  logical ::smbh=.false.
  logical ::agn=.false.

  ! Output times
  real(dp),dimension(1:MAXOUT)::aout=1.1       ! Output expansion factors
  real(dp),dimension(1:MAXOUT)::tout=0.0       ! Output times
  real(kind=8)::delta_tout=0,tend=100,delta_tscr=0
  real(kind=8)::delta_aout=0,aend=100
  real(dp)::tout_iout=0.0                      ! Output time
  real(dp)::aout_iout=0.0                      ! Output time

  ! Refinement parameters for each level
  real(dp),dimension(1:MAXLEVEL)::m_refine =-1.0 ! Lagrangian threshold
  real(dp),dimension(1:MAXLEVEL)::r_refine =-1.0 ! Radius of refinement region
  real(dp),dimension(1:MAXLEVEL)::x_refine = 0.0 ! Center of refinement region
  real(dp),dimension(1:MAXLEVEL)::y_refine = 0.0 ! Center of refinement region
  real(dp),dimension(1:MAXLEVEL)::z_refine = 0.0 ! Center of refinement region
  real(dp),dimension(1:MAXLEVEL)::exp_refine = 2.0 ! Exponent for distance
  real(dp),dimension(1:MAXLEVEL)::a_refine = 1.0 ! Ellipticity (Y/X)
  real(dp),dimension(1:MAXLEVEL)::b_refine = 1.0 ! Ellipticity (Z/X)
  real(dp)::var_cut_refine=-1.0 ! Threshold for variable-based refinement
  real(dp)::mass_cut_refine=-1.0 ! Mass threshold for particle-based refinement
  real(dp)::subcycle_factor=0.9 ! Controls automatic subcycle adjustment; set to 0.0 for no subcycling, 1.0 for optimum
  integer::ivar_refine=-1 ! Variable index for refinement

  ! Initial condition files for each level
  logical::multiple=.false.
  integer,parameter::MAXREGION=100
#ifdef __GFORTRAN__
  character(LEN=80),dimension(1:MAXREGION)::initfile
#else
  character(LEN=80),allocatable,dimension(:)::initfile
#endif
  character(LEN=20)::filetype='ascii'

  ! Initial condition regions parameters
  integer                           ::nregion=0
  character(LEN=10),dimension(1:MAXREGION)::region_type='square'
  real(dp),dimension(1:MAXREGION)   ::x_center=0.
  real(dp),dimension(1:MAXREGION)   ::y_center=0.
  real(dp),dimension(1:MAXREGION)   ::z_center=0.
  real(dp),dimension(1:MAXREGION)   ::length_x=1.E10
  real(dp),dimension(1:MAXREGION)   ::length_y=1.E10
  real(dp),dimension(1:MAXREGION)   ::length_z=1.E10
  real(dp),dimension(1:MAXREGION)   ::exp_region=2.0
  real(dp),dimension(1:MAXREGION)   ::rotation_z=0.0 ! rotation about the z-axis

  ! Boundary conditions parameters
  integer,parameter::MAXBOUND=100
  logical                           ::simple_boundary=.false.
  integer                           ::nboundary=0
  integer                           ::icoarse_min=0
  integer                           ::icoarse_max=0
  integer                           ::jcoarse_min=0
  integer                           ::jcoarse_max=0
  integer                           ::kcoarse_min=0
  integer                           ::kcoarse_max=0
  integer ,dimension(1:MAXBOUND)    ::boundary_type=0
  integer ,dimension(1:MAXBOUND)    ::ibound_min=0
  integer ,dimension(1:MAXBOUND)    ::ibound_max=0
  integer ,dimension(1:MAXBOUND)    ::jbound_min=0
  integer ,dimension(1:MAXBOUND)    ::jbound_max=0
  integer ,dimension(1:MAXBOUND)    ::kbound_min=0
  integer ,dimension(1:MAXBOUND)    ::kbound_max=0

  ! logical unit numbers
  integer :: tmp_unit=60, courant_unit=61, bitwise_unit=62, dt_unit=63, header_unit=64

  ! Miscellaneous parameters
  character(len=72) :: hl="------------------------------------------------------------------------"
  character(LEN=80)::infile
end module amr_parameters