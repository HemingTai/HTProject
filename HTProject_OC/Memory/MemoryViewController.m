//
//  MemoryViewController.m
//  HTProject_OC
//
//  Created by Hem1ng on 2019/9/10.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

#import "MemoryViewController.h"

@interface MemoryViewController ()

@property (nonatomic, assign) UILabel *label;

@property (nonatomic, assign) NSString *string;

@end

@implementation MemoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    struct {
        char a;         //1byte
        double b;       //8byte
        int c;          //4byte
        short d;        //2byte
    }struct1;
    
    struct {
        double b;       //8byte
        char a;         //1byte
        short d;        //2byte
        int c;          //4byte
    }struct2;

   /*
    每个特定平台上的编译器都有自己的默认“对齐系数”(也叫对齐模数)。程序员可以通过预编译命令#pragma pack(n)，n=1,2,4,8,16来改变这一系数，其中的n就是你要指定的“对齐系数”。
    
    内存对齐的规则：

    1.数据成员对齐规则：struct 或 union （以下统称结构体）的数据成员，第一个数据成员A放在偏移为 0 的地方，以后每个数据成员B的偏移为(#pragma pack(指定的数n) 与 该数据成员（也就是 B）的自身长度中较小那个数的整数倍，不够整数倍的补齐。
    
    2.数据成员为结构体：如果结构体的数据成员还为结构体，则该数据成员的“自身长度”为其内部最大元素的大小。(struct a 里存有 struct b，b 里有char,int,double等元素，那 b “自身长度”为 8)
    
    3.结构体的整体对齐规则：在数据成员按照上述第一步完成各自对齐之后，结构体本身也要进行对齐。对齐会将结构体的大小调整为(#pragma pack(指定的数n) 与 结构体中的最大长度的数据成员中较小那个的整数倍，不够的补齐。
    
    Xcode 中默认为#pragma pack(8)。如果在代码执行前加一句#pragma pack(1) 时就代表不进行内存对齐，上述代码打印的结果就都为 16。
    */
    
    NSLog(@"%lu----%lu", sizeof(struct1), sizeof(struct2));
        long j = (long)&struct1.a;long k = (long)&struct1.b;long l = (long)&struct1.c;long m = (long)&struct1.d;
//    long j = (long)&struct2.b;long k = (long)&struct2.a;long l = (long)&struct2.d;long m = (long)&struct2.c;
    NSLog(@"%ld-%ld-%ld-%ld", j,k,l,m);
    //解析过程如下：
//    struct {
//        char a;         //1byte         从位置0开始
//        char _pad0[7];  //由于b为8byte并且根据规则1，偏移量要是b的整数倍，所以要补齐7字节成为8的倍数
//        double b;       //8byte         从位置8开始
//        int c;          //4byte         从位置16开始
//        short d;        //2byte         从位置20开始
//        char _pad1[2];  //根据规则3，结构体自身也需要对齐，二结构体自身最大长度为8，所以对齐后要是自身的整数倍，再补齐2byte
//    }struct1;
    
    //为什么要进行内存对齐？因为CPU对未对齐的数据读取，会大大降低 CPU 的性能，CPU读取内存数据是按块读取的，举个🌰：
    // CPU 一般会以 2/4/8/16/32 字节为单位来进行存取操作。我们将这些存取单位也就是块大小称为内存存取粒度。
    //假设 CPU 内存存取粒度为 4，读取数据块大小为4，如果从位置0开始读取，则一次读完，但是如果数据未对齐，从位置1开始读取，则要读取2次
    //而且在读取完两次数据后，还要将 0-3 的数据向上偏移 1 字节，将 4-7 的数据向下偏移 3 字节。最后再将两块数据合并放入寄存器。
    
    
    
    /************************Tagged Pointer特点的介绍：************************
     *1.Tagged Pointer专门用来存储小的对象，例如NSNumber和NSDate
     *2.Tagged Pointer指针的值不再是地址了，而是真正的值。所以实际上它不再是一个对象了，它只是一个披着对象皮的普通变量而已。
     *  所以，它的内存并不存储在堆中，也不需要 malloc 和 free。
     *3.在内存读取上有着 3 倍的效率，创建时比以前快 106 倍。
     *4.Tagged Pointer通过在其最后一个 bit 位设置一个特殊标记，用于将数据直接保存在指针本身中。
     *5.因为Tagged Pointer并不是真正的对象，我们在使用时需要注意不要直接访问其 isa 变量。
     ************************************************************************/
    //问：为什么assign修饰的UILabel, 创建完后会自动释放，再次访问会造成野指针。而assign修饰的NSString,创建完后不会自动释放，再次访问也不会造成野指针？
//    self.label = [[UILabel alloc] init];
    self.string = @"name";
    NSLog(@"%@,%@",self.label, self.string);
    
    
    
    //查看基本类型所占大小
    [self logDataTypeMemorySize];
}

- (void)logDataTypeMemorySize {
    NSLog(@"----在64位机器中：\n");
    NSLog(@"        char类型----%lu个字节\n",sizeof(char));
    NSLog(@"       short类型----%lu个字节\n",sizeof(short));
    NSLog(@"         int类型----%lu个字节\n",sizeof(int));
    NSLog(@"        long类型----%lu个字节\n",sizeof(long));
    NSLog(@"unsigned int类型----%lu个字节\n",sizeof(unsigned int));
    NSLog(@"       float类型----%lu个字节\n",sizeof(float));
    NSLog(@"      double类型----%lu个字节\n",sizeof(double));
    NSLog(@" long double类型----%lu个字节\n",sizeof(long double));
    NSLog(@"------------指针类型----8个字节\n");
    char *p0;
    short *p1;
    int *p2;
    long *p3;
    unsigned int *p4;
    float *p5;
    double *p6;
    long double *p7;
    NSString *str = @"123";
    NSLog(@"        char类型指针----%lu个字节\n",sizeof(p0));
    NSLog(@"       short类型指针----%lu个字节\n",sizeof(p1));
    NSLog(@"         int类型指针----%lu个字节\n",sizeof(p2));
    NSLog(@"        long类型指针----%lu个字节\n",sizeof(p3));
    NSLog(@"unsigned int类型指针----%lu个字节\n",sizeof(p4));
    NSLog(@"       float类型指针----%lu个字节\n",sizeof(p5));
    NSLog(@"      double类型指针----%lu个字节\n",sizeof(p6));
    NSLog(@" long double类型指针----%lu个字节\n",sizeof(p7));
    NSLog(@"  NSString *类型指针----%lu个字节\n",sizeof(str));
}

@end
