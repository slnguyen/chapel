/* -*-Mode: c++;-*-
 Copyright 2003 John Plevyak, All Rights Reserved, see COPYRIGHT file
*/
#ifndef _scope_h_
#define _scope_h_

class Sym;

// must match the corresponding D_SCOPE_XXX if the DParser is used
enum Scope_kind { 
  Scope_INHERIT, Scope_RECURSIVE, Scope_PARALLEL, Scope_SEQUENTIAL
};

class Scope : public gc {
 public:
  unsigned int		kind:2;
  Map<char *, Sym *>	hash;
  Vec<Scope*>		dynamic;
  Scope 		*up;
  Scope			*next;
  
  Sym			*in;
  Sym *			get(char *name);
  Sym *			get_local(char *name);
  void			put(char *name, Sym *s);

  Scope *		global();
  Scope *		module();
  
  Scope() : kind(Scope_RECURSIVE), up(0), next(0) {}
  Scope(Scope *s, unsigned int k, Sym *an_in) : up(s), next(0), in(an_in) {
    if (k == Scope_INHERIT)
      kind = up->kind;
    else
      kind = k;
  }
};
#define forv_Scope(_x, _v) forv_Vec(Scope, _x, _v)


#endif
