using UnityEngine;
public class ObjectPool<T> where T : new()
{
    private T[] pool;
    private int size;
    private int index;
    public int GetSize()
    {
        return size;
    }
    public void Init(int count)
    {
        size = count;
        pool = new T[count];
        for (int i = 0; i < count; ++i)
        {
            pool[i] = new T();
        }
    }

    public T GetObject()
    {
        return pool[index++ % size];
    }

    public T[] GetPool()
    {
        return pool;
    }
}
