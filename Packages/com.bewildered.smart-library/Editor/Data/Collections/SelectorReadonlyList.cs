using System;
using System.Collections;
using System.Collections.Generic;

namespace Bewildered.SmartLibrary
{
    public class SelectorReadonlyList<TSource, TResult> : IReadOnlyList<TResult>
    {
        private int _count;
        private bool _isReadOnly;
        public IList<TSource> Source { get; set; }
        
        public Func<TSource, TResult> Selector { get; set; }
        
        public int Count
        {
            get { return Source.Count; }
        }
        
        public TResult this[int index]
        {
            get { return Selector(Source[index]);}
        }

        public SelectorReadonlyList(IList<TSource> source, Func<TSource, TResult> selector)
        {
            Source = source;
            Selector = selector;
        }
        
        public IEnumerator<TResult> GetEnumerator()
        {
            for (int i = 0; i < Source.Count; i++)
            {
                yield return Selector(Source[i]);
            }
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return GetEnumerator();
        }
    }
}