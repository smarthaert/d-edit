#ifndef __IO_H__
#define __IO_H__


typedef struct file_descriptor { 
    FILE *f;
    char *name;
#ifdef __VMS
    void *fab;
#endif
    int   error;
    short mode; 
    short state;
} file_descriptor;

typedef struct text_descriptor { 
    file_descriptor desc;
    char            record;
} text_descriptor;

extern boolean pio_ignore_error;

#ifdef __cplusplus
extern "C" { 
#endif

void pio_initialize();

void pio_rewrite_file(file_descriptor* fd, 
		      size_t record_size,
		      const char* file_name, const char* options, 
		      integer* error_code); 

void pio_reset_file(file_descriptor* fd, 
		    size_t record_size,
		    const char* file_name, const char* options, 
		    integer* error_code); 

void pio_get_record(file_descriptor* fd, void* record, size_t record_size);


void pio_put_record(file_descriptor* fd, void* record, size_t record_size);


void pio_access_record(file_descriptor* fd, void* record, size_t record_size);


void pio_store_record(file_descriptor* fd, void* record, size_t record_size, 
		      void* src);


void pio_read_record(file_descriptor* fd, void* record, size_t record_size, 
		     void* dst);

void pio_write_record(file_descriptor* fd, void* record, size_t record_size,
		  void* src);

void pio_copy_record(file_descriptor* src_fd, void* src_record, 
		     file_descriptor* dst_fd, void* dst_record, 
		     size_t record_size);

boolean pio_check_end_of_file(file_descriptor *fd); 

boolean pio_check_end_of_line(text_descriptor *td); 

integer pio_iostatus(file_descriptor *fd);

boolean pio_ioerror(file_descriptor *fd);

void pio_file_ignore_error(file_descriptor* fd);

void pio_close_file(file_descriptor* fd);

void pio_seek_file(file_descriptor* fd, void* record, size_t record_size, 
	       integer position);

void pio_rename_file(file_descriptor* fd, const char* new_name);

void pio_flush_file(file_descriptor* fd);

void pio_delete_file(file_descriptor* fd);
 
#ifdef __VMS
integer pio_get_file_version(file_descriptor* fd);
#endif


void pio_input_real(text_descriptor* td, real* val); 

void pio_input_integer(text_descriptor* td, integer* val); 

void pio_input_char(text_descriptor* td, char* val); 

void pio_input_string(text_descriptor* td, char* buf, size_t len);

void pio_input_newline(text_descriptor* td);


void pio_output_real(text_descriptor* td, real val, const int* width, 
		 const int* prec); 

void pio_output_integer(text_descriptor* td, integer val, 
			const int* width); 

void pio_output_char(text_descriptor* td, char val, const int* width); 

void pio_output_boolean(text_descriptor* td, boolean val, 
			const int* width); 

void pio_output_string(text_descriptor* td, const char* buf, size_t len, 
		       const int* width);

void pio_output_newline(text_descriptor* td);

void pio_output_end_of_page(text_descriptor* td);

typedef struct { int dummy; } new_line_marker;
extern new_line_marker NL;

#ifdef __cplusplus

}


template<class T>
class file { 
  protected: 
    file_descriptor desc;
    T               record;
    
  public:
    friend void rewrite(file& f, const char* file_name = NULL, 
			const char* options = NULL, 
			integer& error_code = *(integer*)0) 
    { 
	pio_rewrite_file(&f.desc, sizeof(T), file_name, options, &error_code);
    }

    friend void reset(file& f, const char* file_name = NULL, 
		      const char* options = NULL, 
		      integer& error_code = *(integer*)0) 
    { 
	pio_reset_file(&f.desc, sizeof(T), file_name, options, &error_code); 
    }

    friend void get(file& f) 
    {
        pio_get_record(&f.desc, (void*)&f.record, sizeof(T)); 
    }

    friend void put(file& f) 
    {
        pio_put_record(&f.desc, (void*)&f.record, sizeof(T));
    }

    friend boolean eof(file& f) 
    {
        return pio_check_end_of_file(&f.desc);
    }

    friend integer iostatus(file& f) 
    {
        return pio_iostatus(&f.desc);
    }

    friend boolean ioerror(file& f) 
    {
        return pio_ioerror(&f.desc); 
    }

    friend void close(file& f) 
    {
        pio_close_file(&f.desc);
    }

    friend void seek(file& f, integer position) 
    {
        pio_seek_file(&f.desc, (void*)&f.record, sizeof(T), position);
    }

    friend void rename(file& f, const char* new_name)
    {
        pio_rename_file(&f.desc, new_name); 
    }

    friend void flush(file& f) 
    {
        pio_flush_file(&f.desc);
    }

    friend void delete_file(file& f)
    { 
        pio_delete_file(&f.desc);
    }

    friend void noioerror(file& f) 
    {
        pio_file_ignore_error(&f.desc);
    }

    T& operator*() 
    {
	pio_access_record(&desc, (void*)&record, sizeof(T)); 
	return record; 
    }

    T* operator->() 
    {
	pio_access_record(&desc, (void*)&record, sizeof(T)); 
	return &record; 
    }

    friend void store(file& f, T const& record) 
    { 
	pio_store_record(&f.desc, (void*)&f.record, sizeof(T), (void*)&record);
    }

    file& operator >> (T& x) 
    { 
	pio_read_record(&desc, (void*)&record, sizeof(T), (void*)&x);
	return *this;
    }
    file& operator >> (file const& f) 
    { 
	pio_copy_record(&desc, (void*)&record, 
			(file_descriptor*)&f.desc, (void*)&f.record, 
			sizeof(T));
	return *this;
    }
    file& operator << (T const& x) 
    { 
	pio_write_record(&desc, (void*)&record, sizeof(T), (void*)&x);
	return *this;
    }

    friend boolean file_is_opened(file const& f) 
    { 
	return f.desc.f != NULL; 
    }

    file() { desc.f = NULL; desc.name = NULL; }
    ~file() { pio_close_file(&desc); }
};

class text;

extern "C" text input, output;

class text : public file<char> { 
  public:
    friend boolean eof()  
    { 
        return pio_check_end_of_file(&input.desc);
    }
    friend boolean eoln(text& t) 
    {
        return pio_check_end_of_line((text_descriptor*)&t);
    }
    friend boolean eoln() 
    {
        return pio_check_end_of_line((text_descriptor*)&input);
    }

    text& operator >> (real& x) 
    {
	pio_input_real((text_descriptor*)this, &x);
	return *this;
    } 

    text& operator >> (integer& x) 
    {
	pio_input_integer((text_descriptor*)this, &x);
	return *this;
    } 

    text& operator >> (unsigned& x) 
    {
	integer tmp;
	pio_input_integer((text_descriptor*)this, &tmp);
	x = tmp;
	return *this;
    } 

    text& operator >> (short& x) 
    {
	integer tmp;
	pio_input_integer((text_descriptor*)this, &tmp);
	x = tmp;
	return *this;
    } 

    text& operator >> (unsigned short& x) 
    {
	integer tmp;
	pio_input_integer((text_descriptor*)this, &tmp);
	x = tmp;
	return *this;
    } 

    text& operator >> (unsigned char& x) 
    {
	integer tmp;
	pio_input_integer((text_descriptor*)this, &tmp);
	x = tmp;
	return *this;
    } 

    text& operator >> (signed char& x) 
    {
	integer tmp;
	pio_input_integer((text_descriptor*)this, &tmp);
	x = tmp;
	return *this;
    } 

    text& operator >> (char& x) 
    { 
	pio_input_char((text_descriptor*)this, &x);
	return *this; 
    }

    text& operator >> (new_line_marker&) 
    { 
	pio_input_newline((text_descriptor*)this);
	return *this; 
    }

    text& operator << (real x) 
    {
	pio_output_real((text_descriptor*)this, x, NULL, NULL);
	return *this;
    } 

    text& operator << (integer x) 
    {
	pio_output_integer((text_descriptor*)this, x, NULL);
	return *this;
    } 

    text& operator << (size_t x) 
    {
	pio_output_integer((text_descriptor*)this, x, NULL);
	return *this;
    } 

    friend char* btos(boolean val) // convert boolean to ascii string
    {
	return val ? " TRUE" : "FALSE"; 
    }

    text& operator << (char x) 
    {
	pio_output_char((text_descriptor*)this, x, NULL);
	return *this;
    } 

    text& operator << (const char* x) 
    {
	pio_output_string((text_descriptor*)this, x, strlen(x), NULL);
	return *this;
    } 

    text& operator << (new_line_marker&) 
    { 
	pio_output_newline((text_descriptor*)this);
	return *this; 
    }

    friend void page(text& t) 
    {
        pio_output_end_of_page((text_descriptor*)&t);
    }
    friend void page() 
    {
        pio_output_end_of_page((text_descriptor*)&output);
    }
};

template<int size>
class format_string { 
  private:
    char*   buf; 
    int     width;
    
  public:
    friend text& operator << (text& t, format_string const& fs) { 
	pio_output_string((text_descriptor*)&t, fs.buf, size, &fs.width); 
	return t; 
    }
    format_string(const char* buf, integer width) { 
	this->buf = (char*)buf;
	this->width = width;
    }
};

class format_real { 
  private:
    real    val;
    int     width;
    
  public:
    friend text& operator << (text &t, format_real const& fr) { 
	pio_output_real((text_descriptor*)&t, fr.val, &fr.width, NULL);
	return t;
    }
    friend format_real format(real val, integer width) { 
	return format_real(val, width); 
    }
    format_real(real val, integer width) { 
	this->val = val;
	this->width = width;
    }
};


class format_real_wp { 
  private:
    real    val;
    int     width;
    int     prec;
    
  public:
    friend text& operator << (text &t, format_real_wp const& fr) { 
	pio_output_real((text_descriptor*)&t, fr.val, &fr.width, &fr.prec);
	return t;
    }
    friend format_real_wp format(real val, integer width, integer prec) { 
	return format_real_wp(val, width, prec); 
    }
    format_real_wp(real val, integer width, integer prec) { 
	this->val = val;
	this->prec = prec;
	this->width = width;
    }
};

class format_integer { 
  private:
    integer val;
    int     width;
    
  public:
    friend text& operator << (text &t, format_integer const& fi) { 
	pio_output_integer((text_descriptor*)&t, fi.val, &fi.width);
	return t;
    }
    friend format_integer format(integer val, integer width) { 
	return format_integer(val, width); 
    }
    format_integer(integer val, integer width) { 
	this->val = val;
	this->width = width;
    }
};

class format_lpsz { 
  private:
    const char* val;
    int         width;
    
  public:
    friend text& operator << (text &t, format_lpsz const& fs) { 
	pio_output_string((text_descriptor*)&t, fs.val, strlen(fs.val), 
			  &fs.width);
	return t;
    }
    friend format_lpsz format(const char* val, integer width) { 
	return format_lpsz(val, width); 
    }
    format_lpsz(const char* val, integer width) { 
	this->val = val;
	this->width = width;
    }
};

class format_char { 
  private:
    char    val;
    int     width;
    
  public:
    friend text& operator << (text &t, format_char const& fc) { 
	pio_output_char((text_descriptor*)&t, fc.val, &fc.width);
	return t;
    }
    friend format_char format(char val, integer width) { 
	return format_char(val, width); 
    }
    format_char(char val, integer width) { 
	this->val = val;
	this->width = width;
    }
};



#else 

#define file(type) struct {  \
  file_descriptor desc;      \
  type record;               \
}                   
 
typedef text_descriptor text;

extern text input, output;

#define VOID_FILE     {{0}}

#define rewrite(file_variable, file_name, options, error_code)  \
        pio_rewrite_file(&(file_variable).desc, \
			 sizeof((file_variable).record), \
			 file_name, options, error_code)

#define reset(file_variable, file_name, options, error_code) \
        pio_reset_file(&(file_variable).desc, \
		       sizeof((file_variable).record), \
		       file_name, options, error_code)

#define get(file_variable) \
        pio_get_record(&(file_variable).desc, (void*)&(file_variable).record, \
		       sizeof((file_variable).record))

#define put(file_variable) \
        pio_put_record(&(file_variable).desc, (void*)&(file_variable).record, \
		       sizeof((file_variable).record))

#define sread(file_variable, value)  \
        pio_read_record(&(file_variable).desc, (void*)&(file_variable).record,\
			sizeof((file_variable).record), (void*)&(value)) 

#define scopy(src_file, dst_file)  \
        pio_copy_record(&(src_file).desc, (void*)&(src_file).record,\
			&(dst_file).desc, (void*)&(dst_file).record,\
			sizeof((src_file).record))

#define swrite(file_variable, value) \
        pio_write_record(&(file_variable).desc,(void*)&(file_variable).record,\
			 sizeof((file_variable).record), (void*)&(value)) 

#define access(file_variable) \
        (pio_access_record(&(file_variable).desc, \
			   (void*)&(file_variable).record, \
			   sizeof((file_variable).record)), \
	 &(file_variable).record)   

#define store(file_variable, value) \
        pio_store_record(&(file_variable).desc, \
			 (void*)&(file_variable).record, \
			 sizeof((file_variable).record), (void*)&(value)) 

#define eof(file_variable) \
        pio_check_end_of_file(&(file_variable).desc)

#define iostatus(file_variable) \
        pio_iostatus(&(file_variable).desc)

#define ioerror(file_variable) \
        pio_ioerror(&(file_variable).desc)


#define close(file_variable) \
        pio_close_file(&(file_variable).desc)

#define seek(file_variable, position) \
        pio_seek_file(&(file_variable).desc, (void*)&(file_variable).record, \
		      sizeof((file_variable).record), position)

#define rename(file_variable, new_name) \
        pio_rename_file(&(file_variable).desc, new_name)

#define flush(file_variable) \
        pio_flush_file(&(file_variable).desc)

#define delete_file(file_variable) \
        pio_delete_file(&(file_variable).desc)

#define noioerror(file_variable) \
        pio_file_ignore_error(&(file_variable).desc)

#ifdef __VMS
#define get_file_version(file_variable) \
       pio_get_file_version(&(file_variable).desc)
#endif


#define file_is_opened(file_variable)  ((file_variable).desc.f != NULL)


#define page(text_variable) \
        pio_output_end_of_page(&text_variable)

#define eoln(text_variable) \
        pio_check_end_of_line(&text_variable)


void tread(text* text_file, char* format_string, ...);

void twrite(text* text_file, char* format_string, ...);

void cread(char* format_string, ...);

void cwrite(char* format_string, ...);

#endif

#endif
