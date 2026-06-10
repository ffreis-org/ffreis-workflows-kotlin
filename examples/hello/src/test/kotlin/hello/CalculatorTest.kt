package hello

import kotlin.test.Test
import kotlin.test.assertEquals

class CalculatorTest {
    @Test
    fun adds() {
        assertEquals(5, Calculator.add(2, 3))
    }

    @Test
    fun multiplies() {
        assertEquals(6, Calculator.multiply(2, 3))
    }
}
