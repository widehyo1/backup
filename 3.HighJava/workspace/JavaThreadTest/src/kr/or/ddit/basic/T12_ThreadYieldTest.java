/*
 * 21/08/31 
 * author : Lee KwangHyo
 */

package kr.or.ddit.basic;

public class T12_ThreadYieldTest {

    /*
     * yield() 메서드에 대하여...
     *
     * 1. 현재 실행 대기중인 동등한 우선순위 이상의 다른 스레드에게 실행기회를 제공한다.
     * 2. 현재 실행중인 스레드의 상태를 Runnable 상태로 바꾼다.
     * 3. yield()메서드를 실행환다고 해서 현재 실행중인 스레드가 곧바로 Runnable상태로
     *    전이된다고 확신할 수 없다.
     */
    public static void main(String[] args) {
        Thread th1 = new YieldThreadEx1();
        Thread th2 = new YieldThreadEx2();

        th1.start();
        th2.start();

    }
}

class YieldThreadEx1 extends Thread {
    public YieldThreadEx1() {
        super("YieldThreadEx1"); // Thread의 이름을 지정하는 생성자 없을시 Thread-01,...이 이름이 됨
    }
    @Override
    public void run(){
        for(int i=0; i<10; i++){
            System.out.println(
                    Thread.currentThread().getName() + " : " + i);
            Thread.yield(); // 양보하기
        }
    }
}
class YieldThreadEx2 extends Thread {
    public YieldThreadEx2() {
        super("YieldThreadEx2");
    }
    @Override
    public void run(){
        for(int i=0; i<10; i++){
            System.out.println(
                    Thread.currentThread().getName() + " : " + i);
        }
    }
}
