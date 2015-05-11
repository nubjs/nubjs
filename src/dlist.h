#ifndef SRC_DLIST_H_
#define SRC_DLIST_H_

typedef struct dlist {
  struct dlist* prev;
  struct dlist* next;
  void* data;
} dlist;


static inline void dlist_init(dlist* dl) {
  dl->prev = dl;
  dl->next = dl;
}


static inline bool dlist_isempty(dlist* dl) {
  return dl->next == dl;
}


static inline void dlist_insert(dlist* dl, dlist* item) {
  dl->next->prev = item;
  item->next = dl->next;
  item->prev = dl;
  dl->next = item;
}


static inline void dlist_remove(dlist* dl) {
  dl->next->prev = dl->prev;
  dl->prev->next = dl->next;
}


static inline dlist* dlist_next(dlist* dl) {
  return dl->next;
}


static inline dlist* dlist_prev(dlist* dl) {
  return dl->prev;
}

#endif  // SRC_DLIST_H_
