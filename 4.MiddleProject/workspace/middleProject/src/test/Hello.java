 package test;

import lilys.VO;

public class Hello {
	public static void main(String[] args) {
		System.out.println("hello ! Nice to be here !");

		VO vo = new VO();
		vo.setName("광효");
		vo.setHeightCm(200);
		vo.setWeightKg(500);

		System.out.println( vo.getName()+" : "+vo.getHeightCm()+"cm, "+vo.getWeightKg()+"kg");
		System.out.println();
		
		System.out.println("수정성공");
	}
}
