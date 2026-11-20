template<class T, unsigned N> struct Buffer {};
template<template<class> class T> struct CharBuffer { T<char> value; };
CharBuffer<Buffer> invalid;
