class TSemaphore {
public:
      int count;
      TNSCollection *List;
      TSemaphore();
      ~TSemaphore();
      void P();
      void V();
};//TSemaphore
