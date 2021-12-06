package com.noteapplication.android.ui.game

import androidx.annotation.DrawableRes
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.noteapplication.android.R
import com.noteapplication.android.utils.SingleLiveEvent

class GameModel : ViewModel()  {
    /**
     * Отображение состояния поля
     */
    private lateinit var matrix: Array<CellState>

    /**
     * Текущий ход
     */
    private lateinit var currentCellState: CellState
    private val mCellStateByIndex: MutableLiveData<Pair<Int, CellState>> = SingleLiveEvent()
    val cellStateByIndex: LiveData<Pair<Int, CellState>> = mCellStateByIndex

    /**
     * Здесь mCurrentMove является изменяемым и он закрыт для обращения из вне класса,
     * а currentMove является не изменяемым и он доступен снаружи класса.
     */
    private val mCurrentMove = MutableLiveData<CellState>()
    val currentMove: LiveData<CellState> = mCurrentMove

    init {
        initGame()
    }

    private fun initGame() {
        matrix = Array(9) { CellState.None }
        currentCellState = CellState.Close

        mCurrentMove.value = currentCellState

    }

    fun onCellClick(index: Int) {
        matrix[index] = currentCellState

        matrix[index] = currentCellState
        mCellStateByIndex.value = Pair(index, currentCellState)
        currentCellState = if (currentCellState == CellState.Close) CellState.Circle else CellState.Close
        mCurrentMove.value = currentCellState
    }

    enum class CellState(@DrawableRes val icon: Int, val isClickable: Boolean) {
        None(0, true),
        Circle(R.drawable.ic_circle, false),
        Close(R.drawable.ic_close, false)
    }
}