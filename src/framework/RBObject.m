#import <RubyCocoa/RBProxy.h>
#import <Foundation/Foundation.h>
#import <LibRuby/cocoa_ruby.h>


static VALUE rbobj_for(VALUE rbclass, id parent)
{
  
  VALUE rbobj = Qnil;
  if (parent && rb_respond_to(rbclass, rb_intern("new_with_ocid"))) {
    VALUE rb_ocid = UINT2NUM((unsigned int)parent);
    rbobj = rb_funcall(rbclass, rb_intern("new_with_ocid"), 1, rb_ocid);
  }
  else {
    rbobj = rb_funcall(rbclass, rb_intern("new"), 0);
  }
  return rbobj;
}

static VALUE rbclass_for(Class occlass)
{
  id pool = [[NSAutoreleasePool alloc] init];
  id name = NSStringFromClass(occlass);
  VALUE rbclass = rb_const_get(rb_cObject, rb_intern([name cString]));
  [pool release];
  return rbclass;
}

@implementation RBProxy(RBObject)

- init
{
  return [self initWithClass: [self class] parent: nil];
}

- initWithParent: parent
{
  return [self initWithClass: [self class] parent: parent];
}

- initWithClass: (Class)occlass
{
  return [self initWithClass: occlass parent: nil];
}

- initWithClass: (Class)occlass parent: parent
{
  VALUE rb_class = rbclass_for(occlass);
  return [self initWithRubyClass: rb_class parent: parent];
}

///////

- initWithRubyClass: (VALUE)rbclass
{
  return [self initWithRubyClass: rbclass parent: nil];
}

- initWithRubyClass: (VALUE)rbclass parent: parent
{
  VALUE rbobj = rbobj_for(rbclass, parent);
  return [self initWithRubyObject: rbobj parent: parent];
}

@end
