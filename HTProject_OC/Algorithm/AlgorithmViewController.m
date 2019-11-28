//
//  AlgorithmViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/7/22.
//  Copyright © 2019 Hem1ng. All rights reserved.
//  算法

#import "AlgorithmViewController.h"

@interface AlgorithmViewController()

@property(nonatomic, strong) NSMutableArray *array;

@end

@implementation AlgorithmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.array = [NSMutableArray arrayWithArray: @[@9,@4,@6,@3,@2,@8,@1]];
//    [self myTestFunction1];
//    [self myTestFunction2];
//    [self myTestFunction3];
    [self quickSortArrayWithArray:_array leftIndex:0 rightIndex:_array.count-1];
}

// 选择排序: 让数组中的每一个数依次与后面的数进行比较，如果前面的数大于后面的数，则记录下较小值的下标，待一轮循环结束后与最小值位置交换。时间复杂度为O(n^2)
- (void)myTestFunction1
{
    for (NSInteger i=0; i<_array.count-1; i++)
    {
        //min是用来记录最小值的下标，等一轮结束后再和最小值交换位置
        NSInteger min = i;
        for (NSInteger j=i+1; j<_array.count; j++)
        {
            if ([_array[min] integerValue] > [_array[j] integerValue])
            {
                min = j;
            }
        }
        //一轮结束后交换最小值得位置
        if (min != i)
        {
            [_array exchangeObjectAtIndex:i withObjectAtIndex:min];
        }
    }
    NSLog(@"sorted array --- %@", _array);
}

// 冒泡排序: 从数组的第一个元素开始，依次比较相邻的两个元素，若第一个元素比第二个元素大则交换位置，一轮结束最大的数排在末位。时间复杂度最坏O(n^2)
- (void)myTestFunction2
{
    self.array = [NSMutableArray arrayWithArray: @[@3,@5,@1,@4,@2,@7]];
    NSInteger num = 0;
    for (NSInteger i=0; i<_array.count-1; i++)
    {
        for (NSInteger j=0; j<_array.count-1; j++)
        {
            if ([_array[j] integerValue] > [_array[j+1] integerValue])
            {
                [_array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
            num++;
        }
    }
    NSLog(@"sorted array --- %@--num:%@", _array,@(num));
    
    /**************** 上面的排序不够好，每一轮比较完最大的数已确定，后面无需再进行比较 ****************/
    self.array = [NSMutableArray arrayWithArray: @[@3,@5,@1,@4,@2,@7]];
    num = 0;
    for (NSInteger i=0; i<_array.count-1; i++)
    {
        for (NSInteger j=0; j<_array.count-1-i; j++)
        {
            if ([_array[j] integerValue] > [_array[j+1] integerValue])
            {
                [_array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
            }
            num++;
        }
    }
    NSLog(@"sorted array --- %@--num:%@", _array,@(num));
    
    /**************** 上面的排序不够好，如果一开始就是排序好的数组还是要执行两层for循环 ****************/
    self.array = [NSMutableArray arrayWithArray: @[@3,@5,@1,@4,@2,@7]];
    num = 0;
    for (NSInteger i=0; i<_array.count-1; i++)
    {
        //isSorted字段是用来优化性能的，假设已经是排好序的，如果一轮循环结束后还是排好序的，则直接跳出循环，说明不用排序
        BOOL isSorted = YES;
        for (NSInteger j=0; j<_array.count-1-i; j++)
        {
            if ([_array[j] integerValue] > [_array[j+1] integerValue])
            {
                [_array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                isSorted = NO;
            }
            num++;
        }
        if (isSorted)
        {
            break;
        }
    }
    NSLog(@"sorted array --- %@--num:%@", _array,@(num));
    
    /**************** 上面的排序还不够好，有可能已排序好后继续执行多次排序操作 ****************/
    self.array = [NSMutableArray arrayWithArray: @[@3,@5,@1,@4,@2,@7]];
    num = 0;
    NSInteger n = _array.count;
    for (NSInteger i=0; i<_array.count-1; i++)
    {
        //newN字段是用来记录最后一次交换后该元素的下标，一轮循环结束后，如果newN=0,说明已经是排序好的数组，
        //否则该下标后面的元素都是排好序的，那么下一次就可以不用遍历该下标后面的元素，
        NSInteger newN = 0;
        for (NSInteger j=0; j<n-1; j++)
        {
            if ([_array[j] integerValue] > [_array[j+1] integerValue])
            {
                [_array exchangeObjectAtIndex:j withObjectAtIndex:j+1];
                newN = j+1;
            }
            num++;
        }
        n = newN;
        if (n == 0) {
            break;
        }
    }
    NSLog(@"sorted array --- %@--num:%@", _array,@(num));
}

// 插入排序(二分法): 利用二分法找到要插入的位置，然后目标位置后面的元素往后移。
- (void)myTestFunction3
{
    self.array = [NSMutableArray arrayWithArray: @[@3,@5,@1,@4,@2,@7]];
    NSInteger i = 1;
    while (i < _array.count) {
        NSInteger j = i;
        while (j>0 && [_array[j-1] integerValue]>[_array[j] integerValue]) {
            [_array exchangeObjectAtIndex:j-1 withObjectAtIndex:j];
            j--;
        }
        i++;
    }
    NSLog(@"sorted array --- %@", _array);
    
    /**采用二分法进行插入排序*/
    for (NSInteger i=1; i<_array.count; i++)
    {
        NSInteger left = 0;
        NSInteger right = i-1;//插入目标元素的前 i-1 个元素
        NSInteger mid = -1;
        NSInteger temp = [_array[i] integerValue];//要插入的第i个元素
        while (left <= right)
        {
            mid = left+(right-left)/2;
            if ([_array[mid] integerValue] > temp)
            {
                right = mid-1;
            }
            else// 元素相同时，也插入在后面的位置
            {
                left = mid+1;
            }
        }
        // 目标位置 之后的元素 整体移动一位
        for (NSInteger j=i-1; j>=left; j--)
        {
            _array[j+1] = _array[j];
        }
        if (left != i)
        {
            _array[left] = [NSNumber numberWithInteger:temp];
        }
    }
    NSLog(@"sorted array --- %@", _array);
}

// 快速排序: 通过一趟排序将要排序的数据分割成独立的两部分，其中一部分的所有数据都比另外一部分的所有数据都要小，然后再按此方法对这两部分数据分别进行快速排序，整个排序过程可以递归进行，以此达到整个数据变成有序序列。
- (void)quickSortArrayWithArray:(NSMutableArray *)array leftIndex:(NSInteger)low rightIndex:(NSInteger)high
{
    NSInteger i = low;
    NSInteger j = high;
    if (low >= high) {
        return;
    }
    //记录比较基准数
    NSInteger temp = [_array[i] integerValue];
    while (i < j)
    {
        /**** 首先从右边j开始查找比基准数小的值 ***/
        while (i<j && [_array[j] integerValue]>=temp) {
            j--;//如果比基准数大，继续查找
        }
        //如果比基准数小，则将查找到的小值调换到i的位置
        _array[i] = _array[j];
        /**** 当在右边查找到一个比基准数小的值时，就从i开始往后找比基准数大的值 ***/
        while (i<j && [_array[i] integerValue]<=temp) {
            i++;//如果比基准数小，继续查找
        }
        //如果比基准数大，则将查找到的大值调换到j的位置
        _array[j] = _array[i];
    }
    //将基准数放到正确位置
    _array[i] = @(temp);
    /**** 递归排序 ***/
    //排序基准数左边的
    [self quickSortArrayWithArray:_array leftIndex:low rightIndex:i-1];
    //排序基准数右边的
    [self quickSortArrayWithArray:_array leftIndex:i+1 rightIndex:high];
    NSLog(@"sorted array --- %@", _array);
}

@end
