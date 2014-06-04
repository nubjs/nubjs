#ifndef INCLUDE_NUBJS_H_
#define INCLUDE_NUBJS_H_
/* Public API for writing native modules in nubjs.
 *
 * The current plan is to have a very small subset of functionality
 * available, and to have it abstracted. So the user won't have to deal
 * with any V8 API changes. Some of these include:
 *
 * - Export native callback function as a v8::External so it can be passed
 *   as the callback to a given function.
 */

#endif  // INCLUDE_NUBJS_H_
